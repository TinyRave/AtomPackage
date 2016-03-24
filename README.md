# TinyRave

Execute [TinyRave](http://tinyrave.com) tracks in Atom!

![Preview](https://raw.githubusercontent.com/emcmanus/atom-tinyrave/01c2fa9c1b5c10a55a8583e9b3ecd1e8bbdf3d53/preview.png)

## How to Use

Paste a TinyRave track into Atom, for example:

```coffeescript
buildSample = (timeOffset) ->
  Math.sin 55 * Math.PI * 2 * Math.pow(timeOffset, 0.3)
```

_Note: this file will need a `.coffee` extension. Otherwise set the language to CoffeeScript._

Press `cmd + enter` to play (or `ctrl + enter` on Windows).

Press `cmd + .` to stop.

