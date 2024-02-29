# Words of Power Editor

**Words of Power Editor** (`wopeditor`) is a free and open source app
for creation, modification, distribution, and machine recognition of
custom magic symbols in [TexnoMagic] format used in upcoming
[texnoforge] game [Words of Power] and any other games/apps
that choose to adopt this open format and/or tool.

Learn more in **[Intro](intro.md)**.


## Status: stable

Even after two years of no updates, `wopeditor` still works with latest stable
Godot 3.5 - great job Godot devs 🤖

`wopeditor` served me great in:

- Drawing initial [Words of Power] alphabets as seen on [wop.texnoforge.dev],
  eventually leading to the creation of the [TexnoLatin] reference alphabet.
- Training and inspecting GMM models for symbol recognition.
- Testing Godot <-> Python integration and distribution.
- Learning Godot UI and structuring for more complex application.

```
This was a triumph!
I'm making a note here
Huge success!
```

`wopeditor` remains useful for fine-tuning [TexnoMagic] symbol Gaussian Mixture
Models as well as finding and deleting bad symbol drawings.

However, Godot 4 port is unlikely due to:

- Godot 3 -> 4 porting pain and pitfalls.
- `jsonrpcserver` used in [TexnoMagic] as a bridge isn't maintained and doesn't
  work in Python 3.12 :(
- Data analysis and visualisation is simply much easier to do in Python 🐍


## Installation

Please see **[Installation](install.md)**.

<iframe frameborder="0" src="https://itch.io/embed/1088137?bg_color=000000&amp;fg_color=ffffff&amp;link_color=83b6f2&amp;border_color=333333" width="552" height="167"><a href="https://texnoforge.itch.io/wopeditor">Words of Power Editor by texnoforge</a></iframe>


## Bugs and Feature Requests

Please use [GitHub Issues](https://github.com/texnoforge/wopeditor/issues)
to report any problems or feature requests.

Contributions, suggestions, and ideas are always welcome!


## Contact

Feel free to drop by
[#words-of-power @ texnoforge discord](https://discord.gg/3GntNPutEX).

[texnoforge]: https://texnoforge.dev
[TexnoMagic]: https://texnoforge.github.io/texnomagic/
[TexnoLatin]: https://github.com/texnoforge/texnolatin/
[Words of Power]: https://texnoforge.dev/pages/words-of-power/
[python-wopeditor]: https://github.com/texnoforge/python-wopeditor/
[wop.mod.io]: https://wop.mod.io
[wop.texnoforge.dev]: https://wop.texnoforge.dev/
[woptrainer]: https://github.com/texnoforge/woptrainer/
[Godot]: https://godotengine.org
