#
# Top panel: "Now playing track. Cmd+. to stop."
#

module.exports =
class AtomTinyraveView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-tinyrave')

    sandboxContainer = document.createElement('div')
    sandboxContainer.setAttribute('style', 'width: 300px; height: 30px; position: absolute; right: 80px; top: 1px; background-color: #282C34;')
    @sandbox = document.createElement('iframe')
    @sandbox.setAttribute('src', "file://#{__dirname}/TrackRuntime.html")
    @sandbox.setAttribute('style', 'border: 0;')
    sandboxContainer.appendChild(@sandbox)
    @element.appendChild(sandboxContainer)

    @button = button = document.createElement('button')
    button.classList.add('tinyrave-btn')
    button.classList.add('btn')
    button.classList.add('btn-info')
    button.textContent = "Stop"
    button.addEventListener 'click', (event) =>
      @togglePlaying()
    @element.appendChild(button)

    # Create message element
    @message = message = document.createElement('div')
    message.textContent = "Now playing. Ready to share with the world? Upload to TinyRave.com"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  getSandbox: ->
    @sandbox

  togglePlaying: ->
    if @playing
      atom.commands.dispatch(document.querySelector('atom-text-editor'), 'atom-tinyrave:stop')
    else
      atom.commands.dispatch(document.querySelector('atom-text-editor'), 'atom-tinyrave:play')

  getPlaying: -> @playing
  setPlaying: (@playing) ->
    if @playing
      @button.textContent = "Stop"
      @message.textContent = "Now playing. Ready to share with the world? Upload to TinyRave.com"
    else
      @button.textContent = "Play"
      @message.textContent = "Ready to share with the world? Upload to TinyRave.com"
