import * as Maybe from "../Data.Maybe/index.js";
import gaze from "gaze";

export const parseJson = (str) => {
  try {
    return new Maybe.Just(JSON.parse(str));
  } catch (error) {
    return new Maybe.Nothing();
  }
};

export const getName = (obj) => {
  if (typeof obj.name == "string") {
    return new Maybe.Just(obj.name);
  } else {
    return new Maybe.Nothing();
  }
};

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
