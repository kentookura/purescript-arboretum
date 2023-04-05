import * as Penrose from "@penrose/core";

export const diagram = function (prog) {
  return function (element) {
    return function (path) {
      return function (maybeName) {
        return () => Penrose.diagram(prog, element);
      };
    };
  };
};
