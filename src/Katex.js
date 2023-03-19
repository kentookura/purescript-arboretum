import katex from 'katex';

export const _renderToStringNullable = function(str) {
    return function(displayMode) {
        try {
            return katex.renderToString(str, {displayMode: displayMode});
        } catch(error) {
            return null;
        }
    }
  }

export const render = function(string) {
    return function(element) {
        return function(config) {
            console.log("hello")
            return () => katex.render(string, element, config)
        }
    }
}

function effize(method) {
  return function () {
    var me = arguments[arguments.length - 1];
    var args = Array.prototype.slice.call(arguments, 0, -1);
    return function () {
      return me[method].apply(me, args);
    };
  };
}