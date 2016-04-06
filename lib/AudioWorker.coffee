constants = require('./constants')

# Given some source code, this will make an effort to have 1 frame of
# audio available for the AudioContext.
module.exports =
class AudioWorker
  constructor: (source) ->
    blob = new Blob([source])

    @worker = new Worker(URL.createObjectURL(blob))
    @worker.onerror = @_workerError
    @worker.onmessage = @_workerMessage

  pop: ->
    @worker.postMessage(["generate"])
    if @_buffer?
      buffer = @_buffer
      @_buffer = null
      buffer
    else
      buffer = new Float64Array(constants.AUDIO_BUFFER_SIZE * 2)
      buffer.fill 0
      buffer

  terminate: ->
    @worker.terminate()

  _workerMessage: (message) =>
    switch message.data[0]
      when "buffer"
        @_buffer = message.data[1]
      when "log"
        console.log message.data[1]
      else
        console.log "Worker message received. Arguments:"
        console.log message.data

  _workerError: (error) =>
    atom.notifications.addError "Error running track", {detail: "#{error.message}. Line #{error.lineno}", dismissable: true}
    console.log "Worker Error: #{error.message}. Line #{error.lineno}"
    console.log error
    error.preventDefault()
