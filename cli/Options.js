import { sync } from "glob";

export const gazeImpl = (pattern) => {
  return function () {
    return sync(pattern);
  };
};
