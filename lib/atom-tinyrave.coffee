CoffeeScript = require 'coffee-script'
AtomTinyraveView = require './atom-tinyrave-view'
{CompositeDisposable} = require 'atom'
coffeeSourceToMappedJS = require('./mapped_eval').coffeeSourceToMappedJS

module.exports = AtomTinyrave =
  atomTinyraveView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomTinyraveView = new AtomTinyraveView(state.atomTinyraveViewState)
    @modalPanel = atom.workspace.addTopPanel(item: @atomTinyraveView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-tinyrave:play': => @play()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-tinyrave:stop': => @stop()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomTinyraveView.destroy()

  serialize: ->
    atomTinyraveViewState: @atomTinyraveView.serialize()

  toggle: ->
    if @atomTinyraveView.getPlaying()
      @stop()
    else
      play()

  play: ->
    # Compile the editor contents if coffeescript
    source = atom.workspace.getActiveTextEditor().getText()
    grammar = atom.workspace.getActiveTextEditor().getGrammar().name
    if grammar == "CoffeeScript"
      try
        filename = atom.workspace.getActiveTextEditor().getTitle()
        fullPath = atom.workspace.getActiveTextEditor().getPath()
        source = coffeeSourceToMappedJS(source, filename, fullPath)
      catch error
        atom.notifications.addError error.toString(), {dismissable: true}
        console.log error
    else if grammar != "JavaScript"
      atom.notifications.addError "Only CoffeeScript and JavaScript are supported.", {dismissable: true}

    @modalPanel.show()
    @atomTinyraveView.setPlaying(true)

    @atomTinyraveView.initializeSandbox()
    view = @atomTinyraveView.getSandbox()
    view.contentWindow.eval("runEncodedTrackSource(\"#{encodeURIComponent(source)}\")")
    atom.openDevTools()

  stop: ->
    view = @atomTinyraveView.getSandbox()
    view.contentWindow.eval("stopTrack()")
    @atomTinyraveView.setPlaying(false)
