int main (string[] args) {
    var app = new Gtk4Demo.SlidingPuzzleApp ();
    return app.run(args);
}

public class Gtk4Demo.SlidingPuzzleApp : Gtk.Application {
    public SlidingPuzzleApp () {
        Object (application_id: "github.aeldemery.gtk4_sliding_puzzle",
                flags: GLib.ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        var win = active_window;
        if (win == null) {
            win = new MainWindow (this);
        }
        win.present();
    }
}