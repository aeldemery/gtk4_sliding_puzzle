// Copyright (c) 2020 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {
    static Gdk.Paintable portland_rose_texture;
    static Gdk.Paintable linux_admin_texture;
    static Gdk.Paintable linux_penguin_3d_texture;
    static Gdk.Paintable penguine_texture;
    static Gdk.Paintable distrubtion_linux_texture;
    unowned Gdk.Paintable current_texture;

    PuzzleBoard puzzle_board;

    Gtk.SpinButton size_spin;
    Gtk.Label size_label;
    Gtk.Grid tweaks_grid;
    Gtk.ScrolledWindow sw;
    Gtk.Button apply_button;
    Gtk.Button restart_button;
    Gtk.Popover popover;
    Gtk.FlowBox choices;
    Gtk.MenuButton tweak_menu_button;
    Gtk.HeaderBar header;
    Gtk.Image icon;

    unowned Gtk.Image selected_image;
    GLib.List<weak Gtk.FlowBoxChild> selected;
    unowned Gtk.Widget selected_child;

    public MainWindow (Gtk.Application app) {
        Object (application: app);

        title = "Sliding Puzzle";
        set_default_size (600, 500);

        choices = new Gtk.FlowBox ();
        choices.add_css_class ("view");

        icon = new Gtk.Image.from_paintable (portland_rose_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        icon = new Gtk.Image.from_paintable (linux_admin_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        icon = new Gtk.Image.from_paintable (linux_penguin_3d_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        icon = new Gtk.Image.from_paintable (penguine_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        icon = new Gtk.Image.from_paintable (distrubtion_linux_texture);
        icon.icon_size = Gtk.IconSize.LARGE;
        choices.insert (icon, -1);

        sw = new Gtk.ScrolledWindow ();
        sw.set_child (choices);

        tweaks_grid = new Gtk.Grid ();
        tweaks_grid.column_spacing = 10;
        tweaks_grid.row_spacing = 10;
        tweaks_grid.margin_start = 10;
        tweaks_grid.margin_end = 10;
        tweaks_grid.margin_top = 10;
        tweaks_grid.margin_bottom = 10;

        size_label = new Gtk.Label ("Size");
        size_label.xalign = 0;

        size_spin = new Gtk.SpinButton.with_range (2, 10, 1);
        size_spin.value = 3;

        apply_button = new Gtk.Button.with_label ("Apply");
        apply_button.halign = Gtk.Align.END;
        apply_button.clicked.connect (reconfigure);

        tweaks_grid.attach (sw, 0, 0, 2, 1);
        tweaks_grid.attach (size_label, 0, 1, 1, 1);
        tweaks_grid.attach (size_spin, 1, 1, 1, 1);
        tweaks_grid.attach (apply_button, 1, 2, 1, 1);

        popover = new Gtk.Popover ();
        popover.set_child (tweaks_grid);

        tweak_menu_button = new Gtk.MenuButton ();
        tweak_menu_button.icon_name = "emblem-system-symbolic";
        tweak_menu_button.set_popover (popover);

        restart_button = new Gtk.Button.from_icon_name ("view-refresh-symbolic");
        restart_button.clicked.connect (restart);

        header = new Gtk.HeaderBar ();
        header.pack_start (restart_button);
        header.pack_end (tweak_menu_button);

        set_titlebar (header);
    }

    construct {

        portland_rose_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/portland-rose.jpg");
        linux_admin_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/linuxadminhero.jpg");
        linux_penguin_3d_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/linux-penguin-3d-model.jpg");
        penguine_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/penguine.jpg");
        distrubtion_linux_texture = Gdk.Texture.from_resource ("/github/aeldemery/gtk4_sliding_puzzle/distribution-linux.jpg");

        current_texture = penguine_texture;
        puzzle_board = new PuzzleBoard (current_texture);
        set_child (puzzle_board);
        //puzzle_board.grab_focus ();
    }

    void reconfigure () {
        var n_pieces = size_spin.get_value_as_int ();

        selected = choices.get_selected_children ();
        if (selected == null)
            selected_child = choices.get_first_child ();
        else {
            selected_child = selected.data;
        }

        selected_image = (Gtk.Image)((Gtk.FlowBoxChild)child).get_child ();
        current_texture = selected_image.get_paintable ();

        puzzle_board = null;
        puzzle_board = new PuzzleBoard (current_texture, n_pieces);
        set_child (puzzle_board);

        var popover = (Gtk.Popover)size_spin.get_ancestor (typeof (Gtk.Popover));
        popover.popdown ();
        //puzzle_board.grab_focus ();
    }

    void restart () {
        puzzle_board = null;
        puzzle_board = new PuzzleBoard (current_texture);
        set_child (puzzle_board);
        //puzzle_board.grab_focus ();
    }

    protected override void dispose () {
        portland_rose_texture = null;
        linux_admin_texture = null;
        linux_penguin_3d_texture = null;
        penguine_texture = null;
        distrubtion_linux_texture = null;
        current_texture = null;

        if (puzzle_board != null) {
            puzzle_board = null;
        }

        base.dispose ();
    }
}