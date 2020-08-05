// Copyright (c) 2020 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {
    Gdk.Paintable puzzle_texture;

    public MainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        title = "Sliding Puzzle";
        set_default_size (600, 500);

        puzzle_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/portland-rose.jpg");

        setup_ui ();

        var puzzle_board = new PuzzleBoard (puzzle_texture);
        set_child (puzzle_board);
    }

    void setup_ui () {
        var choices = new Gtk.FlowBox ();
        choices.add_css_class ("view");
        var icon = new Gtk.Image.from_paintable (puzzle_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        var sw = new Gtk.ScrolledWindow ();
        sw.set_child (choices);

        var tweaks_grid = new Gtk.Grid ();
        tweaks_grid.column_spacing = 10;
        tweaks_grid.row_spacing = 10;
        tweaks_grid.margin_start = 10;
        tweaks_grid.margin_end = 10;
        tweaks_grid.margin_top = 10;
        tweaks_grid.margin_bottom = 10;

        var size_label = new Gtk.Label ("Size");
        size_label.xalign = 0;

        var size_spin = new Gtk.SpinButton.with_range (2, 10, 1);
        size_spin.value = 3;

        var apply_button = new Gtk.Button.with_label ("Apply");
        apply_button.halign = Gtk.Align.END;

        tweaks_grid.attach (sw, 0, 0, 2, 1);
        tweaks_grid.attach (size_label, 0, 1, 1, 1);
        tweaks_grid.attach (size_spin, 1, 1, 1, 1);
        tweaks_grid.attach (apply_button, 1, 2, 1, 1);

        var popover = new Gtk.Popover ();
        popover.set_child (tweaks_grid);

        var tweak_menu_button = new Gtk.MenuButton ();
        tweak_menu_button.icon_name = "emblem-system-symbolic";
        tweak_menu_button.set_popover (popover);

        var restart_button = new Gtk.Button.from_icon_name ("view-refresh-symbolic");

        var header = new Gtk.HeaderBar ();
        header.pack_start (restart_button);
        header.pack_end (tweak_menu_button);

        set_titlebar (header);
    }
}