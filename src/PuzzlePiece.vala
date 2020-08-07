// Copyright (c) 2020 Ahmed Eldemery
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/* Paintable/A simple paintable
 *
 * GdkPaintable is an interface used by GTK for drawings of any sort
 * that do not require layouting or positioning.
 *
 * This demo code gives a simple example on how a paintable can
 * be created.
 *
 * Paintables can be used in many places inside GTK widgets, but the
 * most common usage is inside GtkImage and that's what we're going
 * to do here.
 */
public class Gtk4Demo.PuzzlePiece : Object, Gdk.Paintable {

    Gdk.Paintable puzzle;
    int x;
    int y;
    uint width;
    uint height;

    public PuzzlePiece (Gdk.Paintable puzzle, int x, int y, uint width, uint height)
    /* These are sanity checks, so that we get warnings if we accidentally
     * do anything stupid. */
    requires (puzzle != null)
    requires (width > 0)
    requires (height > 0)
    requires (x < width)
    requires (y < height)
    {
        this.puzzle = puzzle;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    /* Here are the accessors that we need to inspect the puzzle
     * pieces in other code.
     */
    public Gdk.Paintable get_puzzle () {
        return puzzle;
    }

    public int get_x () {
        return x;
    }

    public int get_y () {
        return y;
    }

    /* This is the function that draws the puzzle piece.
     * It just draws a rectangular cutout of the puzzle by clipping
     * away the rest.
     */
    protected void snapshot (Gdk.Snapshot snapshot, double width, double height) {
        var gtksnapshot = (Gtk.Snapshot)snapshot;

        gtksnapshot.push_clip ({ { 0, 0 }, { (float) width, (float) height } });
        gtksnapshot.translate ({ -(float) width * x, -(float) height * y });

        puzzle.snapshot (gtksnapshot, width * this.width, height * this.height);

        gtksnapshot.pop ();
    }

    /* The flags are the same as the ones of the puzzle.
     * If the puzzle changes in some way, so do the pieces.
     */
    protected Gdk.PaintableFlags get_flags () {
        return puzzle.get_flags ();
    }

    /* We can compute our width relative to the puzzle.
     * This logic even works for the case where the puzzle
     * has no width, because the 0 return value is unchanged.
     * Round up the value.
     */
    protected int get_intrinsic_width () {
        return (int)((puzzle.get_intrinsic_width () + width - 1) / width);
    }

    /* Do the same thing we did for the width with the height.
     */
    protected int get_intrinsic_height () {
        return (int)((puzzle.get_intrinsic_height () + height - 1) / height);
    }

    /* We can compute our aspect ratio relative to the puzzle.
     * This logic again works for the case where the puzzle
     * has no aspect ratio, because the 0 return value is unchanged.
     */
    protected double get_intrinsic_aspect_ratio () {
        return puzzle.get_intrinsic_aspect_ratio () * height / width;
    }

    protected override void dispose () {
        if (puzzle != null) {
            puzzle = null;
        }
        base.dispose ();
    }
}