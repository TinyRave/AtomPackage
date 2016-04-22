# TinyRave

Run [TinyRave](http://tinyrave.com) tracks in [Atom](http://atom.io)!

![Preview](https://raw.githubusercontent.com/emcmanus/atom-tinyrave/master/preview.png)

## How to Use

Paste a TinyRave track into Atom, for example:

```coffeescript
buildSample = (timeOffset) ->
  Math.sin 55 * Math.PI * 2 * Math.pow(timeOffset, 0.3)
```

_Give the file a `.coffee` extension or manually set the language to CoffeeScript._

Press `cmd + enter` to play (or `ctrl + enter` on Windows).

Press `cmd + .` to stop.

Most errors will show up in the editor, but a few warnings are displayed only in the Developer Tools console.
