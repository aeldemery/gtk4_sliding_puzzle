/* Sliding Puzzle
 *
 * This demo demonstrates how to use gestures and paintables to create a
 * small sliding puzzle game.
 *
 */

public class Gtk4Demo.PuzzleBoard : Gtk.Widget {
    Gtk.Grid puzzle_grid;
    Gtk.AspectFrame frame;
    Gdk.Paintable texture;

    float aspect_ratio = 1.0f;

    static bool solved = false;

    static uint width = 3;
    static uint height = 3;

    static uint pos_x = 0;
    static uint pos_y = 0;

    public PuzzleBoard (Gdk.Paintable puzzle_texture, uint n_pieces = 3) {
        if (texture != null) texture = null;
        texture = puzzle_texture;

        width = height = n_pieces;

        puzzle_grid = new Gtk.Grid ();
        puzzle_grid.column_spacing = 10;
        puzzle_grid.row_spacing = 10;
        puzzle_grid.margin_start = 10;
        puzzle_grid.margin_end = 10;
        puzzle_grid.margin_top = 10;
        puzzle_grid.margin_bottom = 10;
        puzzle_grid.column_homogeneous = true;
        puzzle_grid.row_homogeneous = true;
        puzzle_grid.focusable = true;

        var controller = new Gtk.ShortcutController ();
        controller.scope = Gtk.ShortcutScope.LOCAL;

        controller.add_shortcut (add_move_binding (Gdk.Key.leftarrow, Gdk.Key.KP_Left, -1, 0));
        controller.add_shortcut (add_move_binding (Gdk.Key.rightarrow, Gdk.Key.KP_Right, 1, 0));
        controller.add_shortcut (add_move_binding (Gdk.Key.uparrow, Gdk.Key.KP_Up, 0, -1));
        controller.add_shortcut (add_move_binding (Gdk.Key.downarrow, Gdk.Key.KP_Down, 0, 1));

        puzzle_grid.add_controller (controller);

        var gesture = new Gtk.GestureClick ();
        gesture.pressed.connect (puzzle_button_pressed);

        puzzle_grid.add_controller (gesture);

        frame = new Gtk.AspectFrame (0.5f, 0.5f, aspect_ratio, false);
        frame.obey_child = false;

        start_puzzle ();

        frame.set_child (puzzle_grid);
        frame.set_parent (this);
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.BinLayout));
    }

    construct {
    }

    Gtk.Shortcut add_move_binding (uint key, uint alternative_key, int dx, int dy) {
        return new Gtk.Shortcut.with_arguments (
            new Gtk.AlternativeTrigger (new Gtk.KeyvalTrigger (key, 0), new Gtk.KeyvalTrigger (alternative_key, 0)),
            new Gtk.CallbackAction (puzzle_key_pressed), "(ii)", dx, dy
        );
    }

    protected override void dispose () {
        frame.unparent ();

        base.dispose ();
    }

    void reshuffle () {
        if (solved) {
            start_puzzle ();
        } else {
            shuffle_puzzle ();
        }
        puzzle_grid.grab_focus ();
    }

    void start_puzzle () {
        aspect_ratio = (float) texture.get_intrinsic_aspect_ratio ();
        if (aspect_ratio == 0.0) aspect_ratio = 1.0f;

        /* Reset the variables */
        solved = false;
        pos_x = width - 1;
        pos_y = height - 1;

        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                Gdk.Paintable piece;
                if (x == pos_x && y == pos_y) {
                    piece = null;
                } else {
                    piece = new PuzzlePiece (texture, x, y, width, height);
                }
                var picture = new Gtk.Picture.for_paintable (piece);
                picture.keep_aspect_ratio = false;
                puzzle_grid.attach (picture, x, y);
            }
        }

        shuffle_puzzle ();
    }

    void shuffle_puzzle () {
        uint i, n_steps;

        /* Do this many random moves */
        n_steps = width * height * 50;

        for (i = 0; i < n_steps; i++) {
            /* Get a random number for the direction to move in */
            switch (GLib.Random.int_range (0, 4)) {
                case 0:
                    /* left */
                    move_puzzle (-1, 0);
                    break;

                case 1:
                    /* up */
                    move_puzzle (0, -1);
                    break;

                case 2:
                    /* right */
                    move_puzzle (1, 0);
                    break;

                case 3:
                    /* down */
                    move_puzzle (0, 1);
                    break;

                default:
                    assert_not_reached ();
            }
        }
    }

    bool move_puzzle (int dx, int dy) {
        uint next_x, next_y;

        /* We don't move anything if the puzzle is solved */
        if (solved)
            return false;

        /* Return FALSE if we can't move to where the call
         * wants us to move.
         */
        if ((dx < 0 && pos_x < -dx) ||
            dx + pos_x >= width ||
            (dy < 0 && pos_y < -dy) ||
            dy + pos_y >= height)
            return false;

        /* Compute the new position */
        next_x = pos_x + dx;
        next_y = pos_y + dy;

        /* Get the current and next image */
        var pos = (Gtk.Picture)puzzle_grid.get_child_at ((int) pos_x, (int) pos_y);
        var next = (Gtk.Picture)puzzle_grid.get_child_at ((int) next_x, (int) next_y);

        /* Move the displayed piece. */
        var piece = next.get_paintable ();
        pos.set_paintable (piece);
        next.set_paintable (null);

        /* Update the current position */
        pos_x = next_x;
        pos_y = next_y;

        /* Return TRUE because we successfully moved the piece */
        return true;
    }

    bool check_solved () {
        uint x, y;

        /* Nothing to check if the puzzle is already solved */
        if (solved)
            return true;

        /* If the empty cell isn't in the bottom right,
         * the puzzle is obviously not solved */
        if (pos_x != width - 1 ||
            pos_y != height - 1)
            return false;

        /* Check that all pieces are in the right position */
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                var picture = (Gtk.Picture)puzzle_grid.get_child_at ((int) x, (int) y);
                var piece = (PuzzlePiece) picture.get_paintable ();

                /* empty cell */
                if (piece == null)
                    continue;

                if (piece.get_x () != x || piece.get_y () != y)
                    return false;
            }
        }

        /* We solved the puzzle!
         */
        solved = true;

        /* Fill the empty cell to show that we're done.
         */
        var picture = (Gtk.Picture)puzzle_grid.get_child_at (0, 0);
        var piece = (PuzzlePiece) picture.get_paintable ();

        piece = new PuzzlePiece (piece.get_puzzle (), (int) pos_x, (int) pos_y, width, height);
        picture = (Gtk.Picture)puzzle_grid.get_child_at ((int) pos_x, (int) pos_y);
        picture.set_paintable (piece);

        return true;
    }

    bool puzzle_key_pressed (Gtk.Widget grid, Variant args) {
        int dx, dy;

        args.get ("(ii)", out dx, out dy);

        if (!move_puzzle (dx, dy)) {
            /* Make the error sound and then return TRUE.
             * We handled this key, even though we didn't
             * do anything to the puzzle.
             */
            error_bell ();
            return true;
        }

        check_solved ();

        return true;
    }

    void puzzle_button_pressed (Gtk.Gesture gesture, int n_press, double x, double y) {
        int l, t, i;
        int pos;

        var child = puzzle_grid.pick (x, y, Gtk.PickFlags.DEFAULT);

        if (child == null || child is Gtk.Grid) {
            error_bell ();
            return;
        }

        puzzle_grid.query_child (child, out l, out t, null, null);

        if (l == pos_x && t == pos_y) {
            error_bell ();
        } else if (l == pos_x) {
            pos = (int) pos_y;
            for (i = t; i < pos; i++) {
                if (!move_puzzle (0, -1))
                    error_bell ();
            }
            for (i = pos; i < t; i++) {
                if (!move_puzzle (0, 1))
                    error_bell ();
            }
        } else if (t == pos_y) {
            pos = (int) pos_x;
            for (i = l; i < pos; i++) {
                if (!move_puzzle (-1, 0))
                    error_bell ();
            }
            for (i = pos; i < l; i++) {
                if (!move_puzzle (1, 0))
                    error_bell ();
            }
        } else {
            error_bell ();
        }

        check_solved ();
    }
}