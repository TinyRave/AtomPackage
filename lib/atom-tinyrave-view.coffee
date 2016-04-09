#
# Top panel: "Now playing track. Cmd+. to stop."
#
fs = require 'fs'

module.exports =
class AtomTinyraveView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-tinyrave')

    webViewContainer = document.createElement('div')
    webViewContainer.setAttribute('style', 'width: 300px; height: 30px; position: absolute; right: 80px; top: 3px; background-color: #282C34;')
    @webView = document.createElement('webview')
    @webView.setAttribute('src', "#{__dirname}/TrackRuntime.html")
    webViewContainer.appendChild(@webView)
    @element.appendChild(webViewContainer)

    @button = button = document.createElement('button')
    button.classList.add('tinyrave-btn')
    button.classList.add('btn')
    button.classList.add('btn-info')
    button.textContent = "Stop"
    button.addEventListener 'click', (event) =>
      @toggleClicked()
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

  getWebView: ->
    @webView

  toggleClicked: ->
    if @playing
      atom.commands.dispatch(document.querySelector('atom-text-editor'), 'atom-tinyrave:stop')
    else
      atom.commands.dispatch(document.querySelector('atom-text-editor'), 'atom-tinyrave:play')

  setPlaying: (@playing) ->
    if @playing
      @button.textContent = "Stop"
      @message.textContent = "Now playing. Ready to share with the world? Upload to TinyRave.com"
    else
      @button.textContent = "Play"
      @message.textContent = "Ready to share with the world? Upload to TinyRave.com"

  initializeWebView: ->
    unless @webViewInitialized
      @webViewInitialized = true
      @webView.executeJavaScript(fs.readFileSync("#{__dirname}/player_internals.js", 'utf8'))
      @webView.executeJavaScript(fs.readFileSync("#{__dirname}/track_runtime.js", 'utf8'))
