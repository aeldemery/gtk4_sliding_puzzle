/* Sliding Puzzle
 *
 * This demo demonstrates how to use gestures and paintables to create a
 * small sliding puzzle game.
 *
 */

public class Gtk4Demo.PuzzleBoard : Gtk.Widget {
    Gtk.Grid grid;
    Gtk.AspectFrame frame;

    public PuzzleBoard (Gdk.Paintable puzzle_texture) {
        
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    construct {
        frame = new Gtk.AspectFrame (0.5f, 0.5f, 1.0f, false);

        grid = new Gtk.Grid ();
        grid.column_spacing = 10;
        grid.row_spacing = 10;
        grid.margin_start = 10;
        grid.margin_end = 10;
        grid.margin_top = 10;
        grid.margin_bottom = 10;
        grid.can_focus = true;

        frame.set_child (grid);
        frame.set_parent (this);
    }

    protected override void dispose () {
        frame.unparent ();

        base.dispose ();
    }
}