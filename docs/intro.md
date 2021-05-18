# Intro

**Words of Power Editor** (or `wopeditor`) is going to be a free and open source
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
representations can be created including models to recognize individual
symbols drawn by users in real-time (once it's done).

Please see [TexnoMagic] library which provides technical implementation.


## Planned Features

### UI

* create new alphabets and symbols
* draw symbols using mouse and save to files
* train symbol models which can be used to recognize user drawn symbols
* browse and preview symbols loaded from disk
* easily open relevant files in file manager

### mods

* show and download mods from [wop.mod.io]
* export symbols/alphabets to zip files/[wop.mod.io]

### code

* code is split into small files arranged in a sustainable modular structure including UI
* clean reusable UI code for loading and displaying alphabets/symbols/drawings from disk
* separate `texnomagic` module to easily interface and work with
  symbol/alphabet data on disk - logic separate from UI
* `wopeditor` module can be imported locally but it's also ready be packaged using
  `setuptools` for PyPI, using `PyInstaller` for Windows, and using native
  packaging tools for linux distros

* **more**


[wop.mod.io]: https://wop.mod.io
[TexnoMagic]: https://texnoforge.github.io/texnomagic/
