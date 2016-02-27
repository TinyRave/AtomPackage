constants = require('./constants')
STD_LIB = require('./StdLib').STD_LIB
AudioWorker = require('./AudioWorker')

module.exports =
class AudioPlayer
  constructor: ->
    @globalAudioContext = new (window.AudioContext || window.webkitAudioContext)()

  setTrackSource: (compiledSource) ->
    # Disconnect source. Terminate existing worker.
    # Create worker.
    try @_audioSource.disconnect()
    @_elapsedTime = 0
    @_worker.terminate() if @_worker
    @_worker = new AudioWorker(STD_LIB + compiledSource)
    @_audioSource = @globalAudioContext.createScriptProcessor(constants.AUDIO_BUFFER_SIZE, 0, 2)
    @_audioSource.onaudioprocess = (event) =>
      volume = 0.4
      left  = event.outputBuffer.getChannelData(0)
      right = event.outputBuffer.getChannelData(1)
      nextBuffer = @_worker.pop()
      for i in [0...left.length]
        left[i]  = volume * nextBuffer[ i*2 ]
        right[i] = volume * nextBuffer[ i*2+1 ]
      @_elapsedTime += constants.AUDIO_BUFFER_SIZE / constants.SAMPLE_RATE

  play: ->
    @_audioSource.connect(@globalAudioContext.destination)

  pause: ->
    try @_audioSource.disconnect()

  stop: ->
    try @_audioSource.disconnect()

  getElapsedTime: ->
    @_elapsedTime
