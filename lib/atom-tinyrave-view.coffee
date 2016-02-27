CoffeeScript = require "coffee-script"

#
# Top panel: "Now playing track. Cmd+. to stop."
#

module.exports =
class AtomTinyraveView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-tinyrave')

    button = document.createElement('button')
    button.classList.add('tinyrave-btn')
    button.classList.add('btn')
    button.classList.add('btn-info')
    button.textContent = "Stop"
    button.addEventListener 'click', (event) ->
      atom.commands.dispatch(document.querySelector('atom-text-editor'), 'atom-tinyrave:stop')
    @element.appendChild(button)

    # Create message element
    message = document.createElement('div')
    message.textContent = "Playing"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
