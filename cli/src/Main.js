import gaze from "gaze";

export const gazeImpl = (globs, cb) => {
  gaze(globs, { follow: true }, function (err, watcher) {
    var watched = watcher.watched();
    watcher.on("changed", function (filepath) {
      cb(filepath)();
    });
    watcher.on("added", function (filepath) {
      cb(filepath)();
    });
  });
};
