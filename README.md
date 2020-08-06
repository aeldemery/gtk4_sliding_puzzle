# Sliding Puzzle

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About <a name = "about"></a>

Vala Implementation of Gtk4 Sliding Puzzle demo. This demo shows usage of Keyboard Shortcuts and Gdk.Paintable.

There is currently a couple of issues however, currently double clicking restart button maximize the window!. and clicking the menu button randomly segfaults with this assertion failure.

```
Gdk:ERROR:../gdk/x11/gdkglcontext-x11.c:189:gdk_x11_gl_context_end_frame: assertion failed: (context_x11->frame_fence == 0)
Bail out! Gdk:ERROR:../gdk/x11/gdkglcontext-x11.c:189:gdk_x11_gl_context_end_frame: assertion failed: (context_x11->frame_fence == 0)
fish: “./builddir/meson-out/github.ael…” terminated by signal SIGABRT (Abort)
```

### Prerequisites

The example uses `gtk4 version 3.99.1` and `vala` master branch.

## Screenshot

![Screenshot]()
