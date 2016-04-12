CoffeeScript = require 'coffee-script'
AtomTinyraveView = require './atom-tinyrave-view'
{CompositeDisposable} = require 'atom'
SourceMap = require 'source-map'
fs = require 'fs'
{MessagePanelView, LineMessageView} = require 'atom-message-panel'
{coffeeSourceToMappedJS, coffeeFileToMappedJS} = require('./mapped_eval')

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
    @sourceMap = null
    grammar = atom.workspace.getActiveTextEditor().getGrammar().name
    if grammar == "CoffeeScript"
      try
        filename = atom.workspace.getActiveTextEditor().getTitle()
        fullPath = atom.workspace.getActiveTextEditor().getPath()
        result = coffeeSourceToMappedJS(source, filename, fullPath)
        source = result.source
        @sourceMap = result.sourceMap
      catch error
        atom.notifications.addError error.toString(), {dismissable: true}
        console.log error
    else if grammar != "JavaScript"
      atom.notifications.addError "Only CoffeeScript and JavaScript are supported.", {dismissable: true}

    @modalPanel.show()
    @atomTinyraveView.setPlaying(true)

    @initializeSandbox()

    # Purge any error messages from last session
    if @messages
      @messages.detach()
      @messages.clear()

    view = @atomTinyraveView.getSandbox()
    view.contentWindow.eval("runEncodedTrackSource(\"#{encodeURIComponent(source)}\")")

  stop: ->
    view = @atomTinyraveView.getSandbox()
    view.contentWindow.eval("stopTrack()")
    @atomTinyraveView.setPlaying(false)

  #
  initializeSandbox: ->
    unless @sandboxInitialized
      @sandboxInitialized = true
      sandbox = @atomTinyraveView.getSandbox()
      sandbox.contentWindow.yieldWorker = (worker) =>
        worker.onerror = (error) =>
          unless @messages
            @messages = new MessagePanelView(title: 'Track Errors')
          sourcePosition = { line: error.lineno, column: error.colno }
          if @sourceMap
            consumer = new SourceMap.SourceMapConsumer(@sourceMap)
            sourcePosition = consumer.originalPositionFor({line: error.lineno, column: error.colno})
          @messages.attach()
          @messages.add new LineMessageView(
            line: sourcePosition.line
            character: sourcePosition.column
            message: error.message
            className: 'text-error'
          )

      playerInternals = coffeeFileToMappedJS("#{__dirname}/player_internals.coffee", "player_internals.coffee")
      sandbox.contentWindow.eval(playerInternals)
      sandbox.contentWindow.eval(fs.readFileSync("#{__dirname}/track_runtime.js", 'utf8'))
