# Installation

## Soon™: binaries on itch.io

As soon as `wopeditor` reaches feature parity with `python-wopeditor`, I'll
start providing binaries through [itch.io](https://itch.io) as a primary means
of distribution.

Until that happens you need to... **Use The Source!**


## Use the Source

`wopeditor` is a Free and Open Source Software and you're encouraged to take full advantage of that.

Running `wopeditor` directly from its [source repo][wopeditor-gh] as opposed to
using precompiled binaries has several advanages:

* latest and greatest code (and bugs)
* easy to contribute through [github][wopeditor-gh]
* no random binary blobs from the internet
* wide platform support, especially on open systems
* full control - the open source way

`wopeditor` is tested to run on Windows and Linux but it should work on many
platforms supported byt the Godot Engine and Python modules used by [TexnoMagic].


### Requirement: Godot Engine

At minimum, you need to get the marvelous **[Godot Engine](https://godotengine.org/download)**.


### Requirement: TexnoMagic

`wopeditor` uses [TexnoMagic] python library for the science/magic work behind the scenes.

TexnoMagic isn't strictly required, but `wopeditor` is **limited to basic
functionality** without an access to TexnoMagic TCP server.

You need to [Get Python] and then install `texnomagic` python module available from [PyPI]:

```
pip install -U texnomagic
```

The `-U`/`--upgrade` option tells `pip` to get the latest version available. You
might want to run this command periodically, especially if something is broken -
chances are it's already fixed in latest TexnoMagic release.

Alternatively, you can use TexnoMagic from [source](TexnoMagic):

```
git clone https://github.com/texnoforge/texnomagic
cd texnomagic
pip install -r requirements.txt
pip install .
```

TexnoMagic is a standard python package so you can install it in many ways provided by the python ecosystem.

!!! important
    Regardless of your `TexnoMagic` installation method, make sure the `texnomagic` script
    provided by the python package is available from your system `$PATH`. Running

    ```
    texnomagic --help
    ```

    should print CLI help. If the command is not found, you need to adjust your
    `$PATH` to include the script. Pay attention to `pip` output when installing
    `texnomagic`, it should mention the script location.

### Get the Source

```
git clone https://github.com/texnoforge/wopeditor
```

### Run from Source

You can run `wopeditor` directly using `godot` executable:

```
cd wopeditor
godot .
```

Or simply open `project.godot` in the Godot Editor and hit `F5`:

```
godot wopeditor/project.godot
# press F5 to run
```

Have a nice magic!


[PyPI]: https://pypi.org/project/texnomagic/
[TexnoMagic]: https://texnoforge.github.io/texnomagic/
[Get Python]: https://www.python.org/downloads/
[wopeditor-gh]: https://github.com/texnoforge/wopeditor
