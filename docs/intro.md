# Intro

**Words of Power Editor** (or `wopeditor`) is a Free and Open Source
app for creation, modification, distribution, and machine recognition of custom magic
symbols in [TexnoMagic] format used in upcoming
[texnoforge](https://texnoforge.dev)
game [Words of Power](https://texnoforge.dev/p/words-of-power/)
and any other games/apps that choose to adopt this free format and/or tool.

The goal is to provide users with means to create and share their own custom
symbols by drawing them with mouse or any other pointing device. After
collecting enough drawings of a symbol, a model can be trained and used to
recognize the symbol from user input.

Entire alphabets of symbols with names, meanings, and graphical
representations can be created and shared including models to recognize
individual symbols drawn by users in real-time.

Please see [TexnoMagic] library which provides technical implementation.


## Features

### UI

* create, edit, save, and load TexnoMagic alphabets and symbols
* draw symbols using mouse (or other pointing/touch device) and save to files
* train symbol models which can be used to recognize user drawn symbols
* visual previews of symbol models
* test real-time symbol recognition
* browse and preview symbols loaded from disk
* easily open relevant files in file manager

### mods / community

* show and download mods from [wop.mod.io]
* export symbols/alphabets to zip files/[wop.mod.io]

### code

* written in Godot Engine's native GDScript which is easy to work with (python-ish)
* UI code is split into small files arranged in a sustainable modular structure
* integration with [TexnoMagic] through JSON-RPC over TCP (TexnoMagic client)

* **more**


[wop.mod.io]: https://wop.mod.io
[TexnoMagic]: https://texnoforge.github.io/texnomagic/
