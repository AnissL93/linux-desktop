#!/usr/bin/env python3
"""Generate a pixel-art Xcursor theme (no xcursorgen needed).

usage: make-amber-cursors.py [dest [fill outline name]]
X = outline, O = fill, . = transparent. Defaults: AmberCRT (#ffb000 on #140c00).
Each cursor is written at 2x and 3x (nominal sizes 32 and 48), integer
scaling only so the pixels stay crisp.
"""
import os
import struct
import sys

COLORS = {"X": 0xFF140C00, "O": 0xFFFFB000, ".": 0x00000000}

ARROW = """
X...........
XX..........
XOX.........
XOOX........
XOOOX.......
XOOOOX......
XOOOOOX.....
XOOOOOOX....
XOOOOOOOX...
XOOOOOOOOX..
XOOOOOOOOOX.
XOOOOOOXXXXX
XOOOXOOX....
XOOXXOOX....
XOX..XOOX...
XX...XOOX...
X.....XOOX..
......XOOX..
.......XX...
"""

IBEAM = """
XXXXXXX
XOOXOOX
XXXOXXX
..XOX..
..XOX..
..XOX..
..XOX..
..XOX..
..XOX..
..XOX..
..XOX..
..XOX..
XXXOXXX
XOOXOOX
XXXXXXX
"""

HAND = """
.....XX.........
....XOOX........
....XOOX........
....XOOX........
....XOOX........
....XOOXXX......
....XOOXOOXXX...
....XOOXOOXOOXX.
.XX.XOOXOOXOOXOX
XOOXXOOOOOOOOXOX
XOOOXOOOOOOOOOOX
.XOOXOOOOOOOOOOX
..XOOOOOOOOOOOOX
..XOOOOOOOOOOOX.
...XOOOOOOOOOOX.
...XOOOOOOOOOX..
....XOOOOOOOOX..
....XXXXXXXXXX..
"""

HOURGLASS = """
XXXXXXXXXXX
XOOOOOOOOOX
XXXXXXXXXXX
.XXXXXXXXX.
.XOOOOOOOX.
..XOOOOOX..
...XOOOX...
....XOX....
...XXOXX...
..XXXOXXX..
.XXXOOOXXX.
.XOOOOOOOX.
XXXXXXXXXXX
XOOOOOOOOOX
XXXXXXXXXXX
"""

CROSS = """
....XXX....
....XOX....
....XOX....
....XOX....
XXXXXOXXXXX
XOOOO.OOOOX
XXXXXOXXXXX
....XOX....
....XOX....
....XOX....
....XXX....
"""

# name -> (map, hotspot x, y in unscaled pixels, aliases)
CURSORS = {
    "left_ptr": (ARROW, 0, 0, ["default", "arrow", "top_left_arrow", "left_arrow",
                               "context-menu", "copy", "alias", "move", "dnd-move"]),
    "xterm": (IBEAM, 3, 7, ["text", "ibeam", "vertical-text"]),
    "hand2": (HAND, 5, 0, ["hand1", "hand", "pointer", "pointing_hand", "grab", "grabbing",
                           "openhand", "closedhand", "fleur", "all-scroll"]),
    "watch": (HOURGLASS, 5, 7, ["wait", "left_ptr_watch", "progress", "half-busy"]),
    "crosshair": (CROSS, 5, 5, ["cross", "tcross", "cell", "plus"]),
}

THEME_NAME = "AmberCRT"
SCALES = {32: 2, 48: 3}  # nominal size -> integer scale


def rows(art):
    lines = [l for l in art.strip("\n").split("\n")]
    w = max(len(l) for l in lines)
    return [l.ljust(w, ".") for l in lines]


def image(art, hx, hy, nominal, scale):
    r = rows(art)
    w, h = len(r[0]) * scale, len(r) * scale
    px = b"".join(
        struct.pack("<I", COLORS[r[y // scale][x // scale]])
        for y in range(h) for x in range(w)
    )
    # image chunk header: size, type, nominal size, version, w, h, xhot, yhot, delay
    return struct.pack("<9I", 36, 0xFFFD0002, nominal, 1, w, h,
                       hx * scale, hy * scale, 0) + px


def xcursor(art, hx, hy):
    chunks = [(n, image(art, hx, hy, n, s)) for n, s in SCALES.items()]
    ntoc = len(chunks)
    out = struct.pack("<4sIII", b"Xcur", 16, 0x10000, ntoc)
    pos = 16 + ntoc * 12
    toc, body = b"", b""
    for nominal, data in chunks:
        toc += struct.pack("<III", 0xFFFD0002, nominal, pos)
        body += data
        pos += len(data)
    return out + toc + body


def main(dest):
    cdir = os.path.join(dest, "cursors")
    os.makedirs(cdir, exist_ok=True)
    with open(os.path.join(dest, "index.theme"), "w") as f:
        # anything not drawn here (resize arrows etc.) falls back to Adwaita
        f.write(f"[Icon Theme]\nName={THEME_NAME}\nComment=Pixel cursors\nInherits=Adwaita\n")
    for name, (art, hx, hy, aliases) in CURSORS.items():
        with open(os.path.join(cdir, name), "wb") as f:
            f.write(xcursor(art, hx, hy))
        for a in aliases:
            link = os.path.join(cdir, a)
            if os.path.lexists(link):
                os.remove(link)
            os.symlink(name, link)


if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) >= 4:
        COLORS["O"] = 0xFF000000 | int(a[1].lstrip("#"), 16)
        COLORS["X"] = 0xFF000000 | int(a[2].lstrip("#"), 16)
        THEME_NAME = a[3]
    main(a[0] if a else os.path.expanduser("~/.local/share/icons/AmberCRT"))
