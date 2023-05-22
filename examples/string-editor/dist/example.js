(() => {
  // output/Data.Ord/foreign.js
  var unsafeCompareImpl = function(lt) {
    return function(eq5) {
      return function(gt) {
        return function(x) {
          return function(y) {
            return x < y ? lt : x === y ? eq5 : gt;
          };
        };
      };
    };
  };
  var ordIntImpl = unsafeCompareImpl;
  var ordCharImpl = unsafeCompareImpl;

  // output/Data.Eq/foreign.js
  var refEq = function(r1) {
    return function(r2) {
      return r1 === r2;
    };
  };
  var eqIntImpl = refEq;
  var eqCharImpl = refEq;

  // output/Data.Eq/index.js
  var eqInt = {
    eq: eqIntImpl
  };
  var eqChar = {
    eq: eqCharImpl
  };
  var eq = function(dict) {
    return dict.eq;
  };

  // output/Data.Ordering/index.js
  var LT = /* @__PURE__ */ function() {
    function LT2() {
    }
    ;
    LT2.value = new LT2();
    return LT2;
  }();
  var GT = /* @__PURE__ */ function() {
    function GT2() {
    }
    ;
    GT2.value = new GT2();
    return GT2;
  }();
  var EQ = /* @__PURE__ */ function() {
    function EQ2() {
    }
    ;
    EQ2.value = new EQ2();
    return EQ2;
  }();

  // output/Data.Ring/foreign.js
  var intSub = function(x) {
    return function(y) {
      return x - y | 0;
    };
  };

  // output/Data.Semiring/foreign.js
  var intAdd = function(x) {
    return function(y) {
      return x + y | 0;
    };
  };
  var intMul = function(x) {
    return function(y) {
      return x * y | 0;
    };
  };
  var numAdd = function(n1) {
    return function(n2) {
      return n1 + n2;
    };
  };
  var numMul = function(n1) {
    return function(n2) {
      return n1 * n2;
    };
  };

  // output/Data.Unit/foreign.js
  var unit = void 0;

  // output/Data.Semiring/index.js
  var semiringNumber = {
    add: numAdd,
    zero: 0,
    mul: numMul,
    one: 1
  };
  var semiringInt = {
    add: intAdd,
    zero: 0,
    mul: intMul,
    one: 1
  };
  var mul = function(dict) {
    return dict.mul;
  };
  var add = function(dict) {
    return dict.add;
  };

  // output/Data.Ring/index.js
  var ringInt = {
    sub: intSub,
    Semiring0: function() {
      return semiringInt;
    }
  };

  // output/Data.Ord/index.js
  var ordInt = /* @__PURE__ */ function() {
    return {
      compare: ordIntImpl(LT.value)(EQ.value)(GT.value),
      Eq0: function() {
        return eqInt;
      }
    };
  }();
  var ordChar = /* @__PURE__ */ function() {
    return {
      compare: ordCharImpl(LT.value)(EQ.value)(GT.value),
      Eq0: function() {
        return eqChar;
      }
    };
  }();
  var compare = function(dict) {
    return dict.compare;
  };

  // output/FRP.Event/foreign.js
  var fastForeachThunk = (as) => {
    for (var i2 = 0, l = as.length; i2 < l; i2++) {
      as[i2]();
    }
  };
  var fastForeachE = (as, f) => {
    for (var i2 = 0, l = as.length; i2 < l; i2++) {
      f(as[i2]);
    }
  };
  var fastForeachOhE = (o, f) => {
    for (const a2 in o) {
      f(o[a2]);
    }
  };
  var objHack = () => ({});
  var insertObjHack = (k, v, o) => {
    o[k] = v;
  };
  var deleteObjHack = (k, o) => {
    delete o[k];
  };

  // output/Data.Functor/foreign.js
  var arrayMap = function(f) {
    return function(arr) {
      var l = arr.length;
      var result = new Array(l);
      for (var i2 = 0; i2 < l; i2++) {
        result[i2] = f(arr[i2]);
      }
      return result;
    };
  };

  // output/Control.Semigroupoid/index.js
  var semigroupoidFn = {
    compose: function(f) {
      return function(g2) {
        return function(x) {
          return f(g2(x));
        };
      };
    }
  };
  var compose = function(dict) {
    return dict.compose;
  };

  // output/Control.Category/index.js
  var identity = function(dict) {
    return dict.identity;
  };
  var categoryFn = {
    identity: function(x) {
      return x;
    },
    Semigroupoid0: function() {
      return semigroupoidFn;
    }
  };

  // output/Data.Boolean/index.js
  var otherwise = true;

  // output/Data.Function/index.js
  var flip = function(f) {
    return function(b2) {
      return function(a2) {
        return f(a2)(b2);
      };
    };
  };
  var $$const = function(a2) {
    return function(v) {
      return a2;
    };
  };
  var applyFlipped = function(x) {
    return function(f) {
      return f(x);
    };
  };

  // output/Data.Functor/index.js
  var map = function(dict) {
    return dict.map;
  };
  var mapFlipped = function(dictFunctor) {
    var map18 = map(dictFunctor);
    return function(fa) {
      return function(f) {
        return map18(f)(fa);
      };
    };
  };
  var $$void = function(dictFunctor) {
    return map(dictFunctor)($$const(unit));
  };
  var functorFn = {
    map: /* @__PURE__ */ compose(semigroupoidFn)
  };
  var functorArray = {
    map: arrayMap
  };

  // output/Data.Semigroup/foreign.js
  var concatString = function(s1) {
    return function(s2) {
      return s1 + s2;
    };
  };
  var concatArray = function(xs) {
    return function(ys) {
      if (xs.length === 0)
        return ys;
      if (ys.length === 0)
        return xs;
      return xs.concat(ys);
    };
  };

  // output/Data.Semigroup/index.js
  var semigroupUnit = {
    append: function(v) {
      return function(v1) {
        return unit;
      };
    }
  };
  var semigroupString = {
    append: concatString
  };
  var semigroupArray = {
    append: concatArray
  };
  var append = function(dict) {
    return dict.append;
  };
  var semigroupFn = function(dictSemigroup) {
    var append13 = append(dictSemigroup);
    return {
      append: function(f) {
        return function(g2) {
          return function(x) {
            return append13(f(x))(g2(x));
          };
        };
      }
    };
  };

  // output/Control.Alt/index.js
  var altArray = {
    alt: /* @__PURE__ */ append(semigroupArray),
    Functor0: function() {
      return functorArray;
    }
  };
  var alt = function(dict) {
    return dict.alt;
  };

  // output/Control.Apply/index.js
  var identity2 = /* @__PURE__ */ identity(categoryFn);
  var apply = function(dict) {
    return dict.apply;
  };
  var applySecond = function(dictApply) {
    var apply1 = apply(dictApply);
    var map18 = map(dictApply.Functor0());
    return function(a2) {
      return function(b2) {
        return apply1(map18($$const(identity2))(a2))(b2);
      };
    };
  };
  var lift2 = function(dictApply) {
    var apply1 = apply(dictApply);
    var map18 = map(dictApply.Functor0());
    return function(f) {
      return function(a2) {
        return function(b2) {
          return apply1(map18(f)(a2))(b2);
        };
      };
    };
  };

  // output/Control.Applicative/index.js
  var pure = function(dict) {
    return dict.pure;
  };
  var liftA1 = function(dictApplicative) {
    var apply5 = apply(dictApplicative.Apply0());
    var pure15 = pure(dictApplicative);
    return function(f) {
      return function(a2) {
        return apply5(pure15(f))(a2);
      };
    };
  };

  // output/Unsafe.Coerce/foreign.js
  var unsafeCoerce2 = function(x) {
    return x;
  };

  // output/Control.Monad.ST.Global/index.js
  var toEffect = unsafeCoerce2;

  // output/Control.Monad.ST.Internal/foreign.js
  var map_ = function(f) {
    return function(a2) {
      return function() {
        return f(a2());
      };
    };
  };
  var pure_ = function(a2) {
    return function() {
      return a2;
    };
  };
  var bind_ = function(a2) {
    return function(f) {
      return function() {
        return f(a2())();
      };
    };
  };
  function newSTRef(val) {
    return function() {
      return { value: val };
    };
  }
  var read = function(ref) {
    return function() {
      return ref.value;
    };
  };
  var modifyImpl = function(f) {
    return function(ref) {
      return function() {
        var t = f(ref.value);
        ref.value = t.state;
        return t.value;
      };
    };
  };
  var write = function(a2) {
    return function(ref) {
      return function() {
        return ref.value = a2;
      };
    };
  };

  // output/Control.Bind/index.js
  var identity3 = /* @__PURE__ */ identity(categoryFn);
  var bind = function(dict) {
    return dict.bind;
  };
  var bindFlipped = function(dictBind) {
    return flip(bind(dictBind));
  };
  var join = function(dictBind) {
    var bind1 = bind(dictBind);
    return function(m) {
      return bind1(m)(identity3);
    };
  };

  // output/Control.Monad/index.js
  var ap = function(dictMonad) {
    var bind5 = bind(dictMonad.Bind1());
    var pure11 = pure(dictMonad.Applicative0());
    return function(f) {
      return function(a2) {
        return bind5(f)(function(f$prime) {
          return bind5(a2)(function(a$prime) {
            return pure11(f$prime(a$prime));
          });
        });
      };
    };
  };

  // output/Data.Bounded/foreign.js
  var topInt = 2147483647;
  var bottomInt = -2147483648;
  var topChar = String.fromCharCode(65535);
  var bottomChar = String.fromCharCode(0);
  var topNumber = Number.POSITIVE_INFINITY;
  var bottomNumber = Number.NEGATIVE_INFINITY;

  // output/Data.Bounded/index.js
  var top = function(dict) {
    return dict.top;
  };
  var boundedInt = {
    top: topInt,
    bottom: bottomInt,
    Ord0: function() {
      return ordInt;
    }
  };
  var boundedChar = {
    top: topChar,
    bottom: bottomChar,
    Ord0: function() {
      return ordChar;
    }
  };
  var bottom = function(dict) {
    return dict.bottom;
  };

  // output/Data.Show/foreign.js
  var showIntImpl = function(n) {
    return n.toString();
  };

  // output/Data.Show/index.js
  var showInt = {
    show: showIntImpl
  };
  var show = function(dict) {
    return dict.show;
  };

  // output/Data.Maybe/index.js
  var identity4 = /* @__PURE__ */ identity(categoryFn);
  var Nothing = /* @__PURE__ */ function() {
    function Nothing2() {
    }
    ;
    Nothing2.value = new Nothing2();
    return Nothing2;
  }();
  var Just = /* @__PURE__ */ function() {
    function Just2(value0) {
      this.value0 = value0;
    }
    ;
    Just2.create = function(value0) {
      return new Just2(value0);
    };
    return Just2;
  }();
  var maybe = function(v) {
    return function(v1) {
      return function(v2) {
        if (v2 instanceof Nothing) {
          return v;
        }
        ;
        if (v2 instanceof Just) {
          return v1(v2.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Maybe (line 237, column 1 - line 237, column 51): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
      };
    };
  };
  var isNothing = /* @__PURE__ */ maybe(true)(/* @__PURE__ */ $$const(false));
  var functorMaybe = {
    map: function(v) {
      return function(v1) {
        if (v1 instanceof Just) {
          return new Just(v(v1.value0));
        }
        ;
        return Nothing.value;
      };
    }
  };
  var map2 = /* @__PURE__ */ map(functorMaybe);
  var fromMaybe = function(a2) {
    return maybe(a2)(identity4);
  };
  var fromJust = function() {
    return function(v) {
      if (v instanceof Just) {
        return v.value0;
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 288, column 1 - line 288, column 46): " + [v.constructor.name]);
    };
  };
  var applyMaybe = {
    apply: function(v) {
      return function(v1) {
        if (v instanceof Just) {
          return map2(v.value0)(v1);
        }
        ;
        if (v instanceof Nothing) {
          return Nothing.value;
        }
        ;
        throw new Error("Failed pattern match at Data.Maybe (line 67, column 1 - line 69, column 30): " + [v.constructor.name, v1.constructor.name]);
      };
    },
    Functor0: function() {
      return functorMaybe;
    }
  };
  var applicativeMaybe = /* @__PURE__ */ function() {
    return {
      pure: Just.create,
      Apply0: function() {
        return applyMaybe;
      }
    };
  }();

  // output/Data.Either/index.js
  var Left = /* @__PURE__ */ function() {
    function Left3(value0) {
      this.value0 = value0;
    }
    ;
    Left3.create = function(value0) {
      return new Left3(value0);
    };
    return Left3;
  }();
  var Right = /* @__PURE__ */ function() {
    function Right3(value0) {
      this.value0 = value0;
    }
    ;
    Right3.create = function(value0) {
      return new Right3(value0);
    };
    return Right3;
  }();
  var either = function(v) {
    return function(v1) {
      return function(v2) {
        if (v2 instanceof Left) {
          return v(v2.value0);
        }
        ;
        if (v2 instanceof Right) {
          return v1(v2.value0);
        }
        ;
        throw new Error("Failed pattern match at Data.Either (line 208, column 1 - line 208, column 64): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
      };
    };
  };
  var hush = /* @__PURE__ */ function() {
    return either($$const(Nothing.value))(Just.create);
  }();

  // output/Data.Identity/index.js
  var Identity = function(x) {
    return x;
  };
  var functorIdentity = {
    map: function(f) {
      return function(m) {
        return f(m);
      };
    }
  };
  var applyIdentity = {
    apply: function(v) {
      return function(v1) {
        return v(v1);
      };
    },
    Functor0: function() {
      return functorIdentity;
    }
  };
  var bindIdentity = {
    bind: function(v) {
      return function(f) {
        return f(v);
      };
    },
    Apply0: function() {
      return applyIdentity;
    }
  };
  var applicativeIdentity = {
    pure: Identity,
    Apply0: function() {
      return applyIdentity;
    }
  };
  var monadIdentity = {
    Applicative0: function() {
      return applicativeIdentity;
    },
    Bind1: function() {
      return bindIdentity;
    }
  };

  // output/Data.EuclideanRing/foreign.js
  var intDegree = function(x) {
    return Math.min(Math.abs(x), 2147483647);
  };
  var intDiv = function(x) {
    return function(y) {
      if (y === 0)
        return 0;
      return y > 0 ? Math.floor(x / y) : -Math.floor(x / -y);
    };
  };
  var intMod = function(x) {
    return function(y) {
      if (y === 0)
        return 0;
      var yy = Math.abs(y);
      return (x % yy + yy) % yy;
    };
  };

  // output/Data.CommutativeRing/index.js
  var commutativeRingInt = {
    Ring0: function() {
      return ringInt;
    }
  };

  // output/Data.EuclideanRing/index.js
  var mod = function(dict) {
    return dict.mod;
  };
  var euclideanRingInt = {
    degree: intDegree,
    div: intDiv,
    mod: intMod,
    CommutativeRing0: function() {
      return commutativeRingInt;
    }
  };
  var div = function(dict) {
    return dict.div;
  };

  // output/Data.Monoid/index.js
  var monoidUnit = {
    mempty: unit,
    Semigroup0: function() {
      return semigroupUnit;
    }
  };
  var mempty = function(dict) {
    return dict.mempty;
  };
  var monoidFn = function(dictMonoid) {
    var mempty13 = mempty(dictMonoid);
    var semigroupFn2 = semigroupFn(dictMonoid.Semigroup0());
    return {
      mempty: function(v) {
        return mempty13;
      },
      Semigroup0: function() {
        return semigroupFn2;
      }
    };
  };

  // output/Effect/foreign.js
  var pureE = function(a2) {
    return function() {
      return a2;
    };
  };
  var bindE = function(a2) {
    return function(f) {
      return function() {
        return f(a2())();
      };
    };
  };

  // output/Effect/index.js
  var $runtime_lazy = function(name15, moduleName, init2) {
    var state4 = 0;
    var val;
    return function(lineNumber) {
      if (state4 === 2)
        return val;
      if (state4 === 1)
        throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state4 = 1;
      val = init2();
      state4 = 2;
      return val;
    };
  };
  var monadEffect = {
    Applicative0: function() {
      return applicativeEffect;
    },
    Bind1: function() {
      return bindEffect;
    }
  };
  var bindEffect = {
    bind: bindE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var applicativeEffect = {
    pure: pureE,
    Apply0: function() {
      return $lazy_applyEffect(0);
    }
  };
  var $lazy_functorEffect = /* @__PURE__ */ $runtime_lazy("functorEffect", "Effect", function() {
    return {
      map: liftA1(applicativeEffect)
    };
  });
  var $lazy_applyEffect = /* @__PURE__ */ $runtime_lazy("applyEffect", "Effect", function() {
    return {
      apply: ap(monadEffect),
      Functor0: function() {
        return $lazy_functorEffect(0);
      }
    };
  });
  var functorEffect = /* @__PURE__ */ $lazy_functorEffect(20);
  var applyEffect = /* @__PURE__ */ $lazy_applyEffect(23);
  var lift22 = /* @__PURE__ */ lift2(applyEffect);
  var semigroupEffect = function(dictSemigroup) {
    return {
      append: lift22(append(dictSemigroup))
    };
  };
  var monoidEffect = function(dictMonoid) {
    var semigroupEffect1 = semigroupEffect(dictMonoid.Semigroup0());
    return {
      mempty: pureE(mempty(dictMonoid)),
      Semigroup0: function() {
        return semigroupEffect1;
      }
    };
  };

  // output/Effect.Ref/foreign.js
  var _new = function(val) {
    return function() {
      return { value: val };
    };
  };
  var read2 = function(ref) {
    return function() {
      return ref.value;
    };
  };
  var modifyImpl2 = function(f) {
    return function(ref) {
      return function() {
        var t = f(ref.value);
        ref.value = t.state;
        return t.value;
      };
    };
  };
  var write2 = function(val) {
    return function(ref) {
      return function() {
        ref.value = val;
      };
    };
  };

  // output/Effect.Ref/index.js
  var $$void2 = /* @__PURE__ */ $$void(functorEffect);
  var $$new = _new;
  var modify$prime = modifyImpl2;
  var modify = function(f) {
    return modify$prime(function(s2) {
      var s$prime = f(s2);
      return {
        state: s$prime,
        value: s$prime
      };
    });
  };
  var modify_ = function(f) {
    return function(s2) {
      return $$void2(modify(f)(s2));
    };
  };

  // output/Control.Monad.ST.Internal/index.js
  var $runtime_lazy2 = function(name15, moduleName, init2) {
    var state4 = 0;
    var val;
    return function(lineNumber) {
      if (state4 === 2)
        return val;
      if (state4 === 1)
        throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state4 = 1;
      val = init2();
      state4 = 2;
      return val;
    };
  };
  var modify$prime2 = modifyImpl;
  var modify2 = function(f) {
    return modify$prime2(function(s2) {
      var s$prime = f(s2);
      return {
        state: s$prime,
        value: s$prime
      };
    });
  };
  var functorST = {
    map: map_
  };
  var monadST = {
    Applicative0: function() {
      return applicativeST;
    },
    Bind1: function() {
      return bindST;
    }
  };
  var bindST = {
    bind: bind_,
    Apply0: function() {
      return $lazy_applyST(0);
    }
  };
  var applicativeST = {
    pure: pure_,
    Apply0: function() {
      return $lazy_applyST(0);
    }
  };
  var $lazy_applyST = /* @__PURE__ */ $runtime_lazy2("applyST", "Control.Monad.ST.Internal", function() {
    return {
      apply: ap(monadST),
      Functor0: function() {
        return functorST;
      }
    };
  });
  var applyST = /* @__PURE__ */ $lazy_applyST(47);
  var lift23 = /* @__PURE__ */ lift2(applyST);
  var pure2 = /* @__PURE__ */ pure(applicativeST);
  var semigroupST = function(dictSemigroup) {
    return {
      append: lift23(append(dictSemigroup))
    };
  };
  var monoidST = function(dictMonoid) {
    var semigroupST1 = semigroupST(dictMonoid.Semigroup0());
    return {
      mempty: pure2(mempty(dictMonoid)),
      Semigroup0: function() {
        return semigroupST1;
      }
    };
  };

  // output/Control.Monad.ST.Class/index.js
  var monadSTEffect = {
    liftST: toEffect,
    Monad0: function() {
      return monadEffect;
    }
  };
  var liftST = function(dict) {
    return dict.liftST;
  };

  // output/Data.Array/foreign.js
  var replicateFill = function(count2) {
    return function(value12) {
      if (count2 < 1) {
        return [];
      }
      var result = new Array(count2);
      return result.fill(value12);
    };
  };
  var replicatePolyfill = function(count2) {
    return function(value12) {
      var result = [];
      var n = 0;
      for (var i2 = 0; i2 < count2; i2++) {
        result[n++] = value12;
      }
      return result;
    };
  };
  var replicate = typeof Array.prototype.fill === "function" ? replicateFill : replicatePolyfill;
  var fromFoldableImpl = function() {
    function Cons3(head5, tail2) {
      this.head = head5;
      this.tail = tail2;
    }
    var emptyList = {};
    function curryCons(head5) {
      return function(tail2) {
        return new Cons3(head5, tail2);
      };
    }
    function listToArray(list) {
      var result = [];
      var count2 = 0;
      var xs = list;
      while (xs !== emptyList) {
        result[count2++] = xs.head;
        xs = xs.tail;
      }
      return result;
    }
    return function(foldr5) {
      return function(xs) {
        return listToArray(foldr5(curryCons)(emptyList)(xs));
      };
    };
  }();
  var length = function(xs) {
    return xs.length;
  };
  var indexImpl = function(just) {
    return function(nothing) {
      return function(xs) {
        return function(i2) {
          return i2 < 0 || i2 >= xs.length ? nothing : just(xs[i2]);
        };
      };
    };
  };
  var findIndexImpl = function(just) {
    return function(nothing) {
      return function(f) {
        return function(xs) {
          for (var i2 = 0, l = xs.length; i2 < l; i2++) {
            if (f(xs[i2]))
              return just(i2);
          }
          return nothing;
        };
      };
    };
  };
  var _deleteAt = function(just) {
    return function(nothing) {
      return function(i2) {
        return function(l) {
          if (i2 < 0 || i2 >= l.length)
            return nothing;
          var l1 = l.slice();
          l1.splice(i2, 1);
          return just(l1);
        };
      };
    };
  };
  var reverse = function(l) {
    return l.slice().reverse();
  };
  var sortByImpl = function() {
    function mergeFromTo(compare3, fromOrdering, xs1, xs2, from3, to2) {
      var mid;
      var i2;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from3 + (to2 - from3 >> 1);
      if (mid - from3 > 1)
        mergeFromTo(compare3, fromOrdering, xs2, xs1, from3, mid);
      if (to2 - mid > 1)
        mergeFromTo(compare3, fromOrdering, xs2, xs1, mid, to2);
      i2 = from3;
      j = mid;
      k = from3;
      while (i2 < mid && j < to2) {
        x = xs2[i2];
        y = xs2[j];
        c = fromOrdering(compare3(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i2;
        }
      }
      while (i2 < mid) {
        xs1[k++] = xs2[i2++];
      }
      while (j < to2) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare3) {
      return function(fromOrdering) {
        return function(xs) {
          var out;
          if (xs.length < 2)
            return xs;
          out = xs.slice(0);
          mergeFromTo(compare3, fromOrdering, out, xs.slice(0), 0, xs.length);
          return out;
        };
      };
    };
  }();

  // output/Data.Array.ST/foreign.js
  function newSTArray() {
    return [];
  }
  var pushAll = function(as) {
    return function(xs) {
      return function() {
        return xs.push.apply(xs, as);
      };
    };
  };
  var splice = function(i2) {
    return function(howMany) {
      return function(bs) {
        return function(xs) {
          return function() {
            return xs.splice.apply(xs, [i2, howMany].concat(bs));
          };
        };
      };
    };
  };
  function copyImpl(xs) {
    return function() {
      return xs.slice();
    };
  }
  var freeze = copyImpl;
  var sortByImpl2 = function() {
    function mergeFromTo(compare3, fromOrdering, xs1, xs2, from3, to2) {
      var mid;
      var i2;
      var j;
      var k;
      var x;
      var y;
      var c;
      mid = from3 + (to2 - from3 >> 1);
      if (mid - from3 > 1)
        mergeFromTo(compare3, fromOrdering, xs2, xs1, from3, mid);
      if (to2 - mid > 1)
        mergeFromTo(compare3, fromOrdering, xs2, xs1, mid, to2);
      i2 = from3;
      j = mid;
      k = from3;
      while (i2 < mid && j < to2) {
        x = xs2[i2];
        y = xs2[j];
        c = fromOrdering(compare3(x)(y));
        if (c > 0) {
          xs1[k++] = y;
          ++j;
        } else {
          xs1[k++] = x;
          ++i2;
        }
      }
      while (i2 < mid) {
        xs1[k++] = xs2[i2++];
      }
      while (j < to2) {
        xs1[k++] = xs2[j++];
      }
    }
    return function(compare3) {
      return function(fromOrdering) {
        return function(xs) {
          return function() {
            if (xs.length < 2)
              return xs;
            mergeFromTo(compare3, fromOrdering, xs, xs.slice(0), 0, xs.length);
            return xs;
          };
        };
      };
    };
  }();

  // output/Data.Array.ST/index.js
  var push = function(a2) {
    return pushAll([a2]);
  };

  // output/Data.Foldable/foreign.js
  var foldrArray = function(f) {
    return function(init2) {
      return function(xs) {
        var acc = init2;
        var len = xs.length;
        for (var i2 = len - 1; i2 >= 0; i2--) {
          acc = f(xs[i2])(acc);
        }
        return acc;
      };
    };
  };
  var foldlArray = function(f) {
    return function(init2) {
      return function(xs) {
        var acc = init2;
        var len = xs.length;
        for (var i2 = 0; i2 < len; i2++) {
          acc = f(acc)(xs[i2]);
        }
        return acc;
      };
    };
  };

  // output/Control.Plus/index.js
  var plusArray = {
    empty: [],
    Alt0: function() {
      return altArray;
    }
  };
  var empty = function(dict) {
    return dict.empty;
  };

  // output/Data.Tuple/index.js
  var Tuple = /* @__PURE__ */ function() {
    function Tuple2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Tuple2.create = function(value0) {
      return function(value1) {
        return new Tuple2(value0, value1);
      };
    };
    return Tuple2;
  }();
  var snd = function(v) {
    return v.value1;
  };
  var functorTuple = {
    map: function(f) {
      return function(m) {
        return new Tuple(m.value0, f(m.value1));
      };
    }
  };
  var fst = function(v) {
    return v.value0;
  };
  var curry = function(f) {
    return function(a2) {
      return function(b2) {
        return f(new Tuple(a2, b2));
      };
    };
  };

  // output/Safe.Coerce/index.js
  var coerce = function() {
    return unsafeCoerce2;
  };

  // output/Data.Newtype/index.js
  var coerce2 = /* @__PURE__ */ coerce();
  var unwrap = function() {
    return coerce2;
  };

  // output/Data.Foldable/index.js
  var foldr = function(dict) {
    return dict.foldr;
  };
  var traverse_ = function(dictApplicative) {
    var applySecond3 = applySecond(dictApplicative.Apply0());
    var pure11 = pure(dictApplicative);
    return function(dictFoldable) {
      var foldr22 = foldr(dictFoldable);
      return function(f) {
        return foldr22(function($454) {
          return applySecond3(f($454));
        })(pure11(unit));
      };
    };
  };
  var for_ = function(dictApplicative) {
    var traverse_1 = traverse_(dictApplicative);
    return function(dictFoldable) {
      return flip(traverse_1(dictFoldable));
    };
  };
  var foldl = function(dict) {
    return dict.foldl;
  };
  var foldableMaybe = {
    foldr: function(v) {
      return function(v1) {
        return function(v2) {
          if (v2 instanceof Nothing) {
            return v1;
          }
          ;
          if (v2 instanceof Just) {
            return v(v2.value0)(v1);
          }
          ;
          throw new Error("Failed pattern match at Data.Foldable (line 138, column 1 - line 144, column 27): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
        };
      };
    },
    foldl: function(v) {
      return function(v1) {
        return function(v2) {
          if (v2 instanceof Nothing) {
            return v1;
          }
          ;
          if (v2 instanceof Just) {
            return v(v1)(v2.value0);
          }
          ;
          throw new Error("Failed pattern match at Data.Foldable (line 138, column 1 - line 144, column 27): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
        };
      };
    },
    foldMap: function(dictMonoid) {
      var mempty5 = mempty(dictMonoid);
      return function(v) {
        return function(v1) {
          if (v1 instanceof Nothing) {
            return mempty5;
          }
          ;
          if (v1 instanceof Just) {
            return v(v1.value0);
          }
          ;
          throw new Error("Failed pattern match at Data.Foldable (line 138, column 1 - line 144, column 27): " + [v.constructor.name, v1.constructor.name]);
        };
      };
    }
  };
  var foldMapDefaultR = function(dictFoldable) {
    var foldr22 = foldr(dictFoldable);
    return function(dictMonoid) {
      var append7 = append(dictMonoid.Semigroup0());
      var mempty5 = mempty(dictMonoid);
      return function(f) {
        return foldr22(function(x) {
          return function(acc) {
            return append7(f(x))(acc);
          };
        })(mempty5);
      };
    };
  };
  var foldableArray = {
    foldr: foldrArray,
    foldl: foldlArray,
    foldMap: function(dictMonoid) {
      return foldMapDefaultR(foldableArray)(dictMonoid);
    }
  };
  var foldMap = function(dict) {
    return dict.foldMap;
  };

  // output/Data.FunctorWithIndex/foreign.js
  var mapWithIndexArray = function(f) {
    return function(xs) {
      var l = xs.length;
      var result = Array(l);
      for (var i2 = 0; i2 < l; i2++) {
        result[i2] = f(i2)(xs[i2]);
      }
      return result;
    };
  };

  // output/Data.FunctorWithIndex/index.js
  var mapWithIndex = function(dict) {
    return dict.mapWithIndex;
  };
  var functorWithIndexArray = {
    mapWithIndex: mapWithIndexArray,
    Functor0: function() {
      return functorArray;
    }
  };

  // output/Data.Traversable/foreign.js
  var traverseArrayImpl = function() {
    function array1(a2) {
      return [a2];
    }
    function array2(a2) {
      return function(b2) {
        return [a2, b2];
      };
    }
    function array3(a2) {
      return function(b2) {
        return function(c) {
          return [a2, b2, c];
        };
      };
    }
    function concat2(xs) {
      return function(ys) {
        return xs.concat(ys);
      };
    }
    return function(apply5) {
      return function(map18) {
        return function(pure11) {
          return function(f) {
            return function(array) {
              function go2(bot, top3) {
                switch (top3 - bot) {
                  case 0:
                    return pure11([]);
                  case 1:
                    return map18(array1)(f(array[bot]));
                  case 2:
                    return apply5(map18(array2)(f(array[bot])))(f(array[bot + 1]));
                  case 3:
                    return apply5(apply5(map18(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                  default:
                    var pivot = bot + Math.floor((top3 - bot) / 4) * 2;
                    return apply5(map18(concat2)(go2(bot, pivot)))(go2(pivot, top3));
                }
              }
              return go2(0, array.length);
            };
          };
        };
      };
    };
  }();

  // output/Data.Unfoldable/foreign.js
  var unfoldrArrayImpl = function(isNothing2) {
    return function(fromJust6) {
      return function(fst3) {
        return function(snd3) {
          return function(f) {
            return function(b2) {
              var result = [];
              var value12 = b2;
              while (true) {
                var maybe2 = f(value12);
                if (isNothing2(maybe2))
                  return result;
                var tuple = fromJust6(maybe2);
                result.push(fst3(tuple));
                value12 = snd3(tuple);
              }
            };
          };
        };
      };
    };
  };

  // output/Data.Unfoldable1/foreign.js
  var unfoldr1ArrayImpl = function(isNothing2) {
    return function(fromJust6) {
      return function(fst3) {
        return function(snd3) {
          return function(f) {
            return function(b2) {
              var result = [];
              var value12 = b2;
              while (true) {
                var tuple = f(value12);
                result.push(fst3(tuple));
                var maybe2 = snd3(tuple);
                if (isNothing2(maybe2))
                  return result;
                value12 = fromJust6(maybe2);
              }
            };
          };
        };
      };
    };
  };

  // output/Data.Unfoldable1/index.js
  var fromJust2 = /* @__PURE__ */ fromJust();
  var unfoldable1Array = {
    unfoldr1: /* @__PURE__ */ unfoldr1ArrayImpl(isNothing)(fromJust2)(fst)(snd)
  };

  // output/Data.Unfoldable/index.js
  var fromJust3 = /* @__PURE__ */ fromJust();
  var unfoldr = function(dict) {
    return dict.unfoldr;
  };
  var unfoldableArray = {
    unfoldr: /* @__PURE__ */ unfoldrArrayImpl(isNothing)(fromJust3)(fst)(snd),
    Unfoldable10: function() {
      return unfoldable1Array;
    }
  };

  // output/Data.Array/index.js
  var fromJust4 = /* @__PURE__ */ fromJust();
  var index = /* @__PURE__ */ function() {
    return indexImpl(Just.create)(Nothing.value);
  }();
  var last = function(xs) {
    return index(xs)(length(xs) - 1 | 0);
  };
  var findIndex = /* @__PURE__ */ function() {
    return findIndexImpl(Just.create)(Nothing.value);
  }();
  var deleteAt = /* @__PURE__ */ function() {
    return _deleteAt(Just.create)(Nothing.value);
  }();
  var deleteBy = function(v) {
    return function(v1) {
      return function(v2) {
        if (v2.length === 0) {
          return [];
        }
        ;
        return maybe(v2)(function(i2) {
          return fromJust4(deleteAt(i2)(v2));
        })(findIndex(v(v1))(v2));
      };
    };
  };

  // output/Data.FoldableWithIndex/index.js
  var foldrWithIndex = function(dict) {
    return dict.foldrWithIndex;
  };
  var foldlWithIndex = function(dict) {
    return dict.foldlWithIndex;
  };
  var foldMapWithIndex = function(dict) {
    return dict.foldMapWithIndex;
  };

  // output/Data.List.Types/index.js
  var Nil = /* @__PURE__ */ function() {
    function Nil3() {
    }
    ;
    Nil3.value = new Nil3();
    return Nil3;
  }();
  var Cons = /* @__PURE__ */ function() {
    function Cons3(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Cons3.create = function(value0) {
      return function(value1) {
        return new Cons3(value0, value1);
      };
    };
    return Cons3;
  }();
  var foldableList = {
    foldr: function(f) {
      return function(b2) {
        var rev3 = function() {
          var go2 = function($copy_v) {
            return function($copy_v1) {
              var $tco_var_v = $copy_v;
              var $tco_done = false;
              var $tco_result;
              function $tco_loop(v, v1) {
                if (v1 instanceof Nil) {
                  $tco_done = true;
                  return v;
                }
                ;
                if (v1 instanceof Cons) {
                  $tco_var_v = new Cons(v1.value0, v);
                  $copy_v1 = v1.value1;
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.List.Types (line 107, column 7 - line 107, column 23): " + [v.constructor.name, v1.constructor.name]);
              }
              ;
              while (!$tco_done) {
                $tco_result = $tco_loop($tco_var_v, $copy_v1);
              }
              ;
              return $tco_result;
            };
          };
          return go2(Nil.value);
        }();
        var $284 = foldl(foldableList)(flip(f))(b2);
        return function($285) {
          return $284(rev3($285));
        };
      };
    },
    foldl: function(f) {
      var go2 = function($copy_b) {
        return function($copy_v) {
          var $tco_var_b = $copy_b;
          var $tco_done1 = false;
          var $tco_result;
          function $tco_loop(b2, v) {
            if (v instanceof Nil) {
              $tco_done1 = true;
              return b2;
            }
            ;
            if (v instanceof Cons) {
              $tco_var_b = f(b2)(v.value0);
              $copy_v = v.value1;
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.List.Types (line 111, column 12 - line 113, column 30): " + [v.constructor.name]);
          }
          ;
          while (!$tco_done1) {
            $tco_result = $tco_loop($tco_var_b, $copy_v);
          }
          ;
          return $tco_result;
        };
      };
      return go2;
    },
    foldMap: function(dictMonoid) {
      var append22 = append(dictMonoid.Semigroup0());
      var mempty5 = mempty(dictMonoid);
      return function(f) {
        return foldl(foldableList)(function(acc) {
          var $286 = append22(acc);
          return function($287) {
            return $286(f($287));
          };
        })(mempty5);
      };
    }
  };

  // output/Data.List/index.js
  var reverse2 = /* @__PURE__ */ function() {
    var go2 = function($copy_v) {
      return function($copy_v1) {
        var $tco_var_v = $copy_v;
        var $tco_done = false;
        var $tco_result;
        function $tco_loop(v, v1) {
          if (v1 instanceof Nil) {
            $tco_done = true;
            return v;
          }
          ;
          if (v1 instanceof Cons) {
            $tco_var_v = new Cons(v1.value0, v);
            $copy_v1 = v1.value1;
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.List (line 368, column 3 - line 368, column 19): " + [v.constructor.name, v1.constructor.name]);
        }
        ;
        while (!$tco_done) {
          $tco_result = $tco_loop($tco_var_v, $copy_v1);
        }
        ;
        return $tco_result;
      };
    };
    return go2(Nil.value);
  }();

  // output/Partial.Unsafe/foreign.js
  var _unsafePartial = function(f) {
    return f();
  };

  // output/Partial/foreign.js
  var _crashWith = function(msg) {
    throw new Error(msg);
  };

  // output/Partial/index.js
  var crashWith = function() {
    return _crashWith;
  };

  // output/Partial.Unsafe/index.js
  var crashWith2 = /* @__PURE__ */ crashWith();
  var unsafePartial = _unsafePartial;
  var unsafeCrashWith = function(msg) {
    return unsafePartial(function() {
      return crashWith2(msg);
    });
  };

  // output/Data.Map.Internal/index.js
  var Leaf = /* @__PURE__ */ function() {
    function Leaf2() {
    }
    ;
    Leaf2.value = new Leaf2();
    return Leaf2;
  }();
  var Two = /* @__PURE__ */ function() {
    function Two2(value0, value1, value22, value32) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
    }
    ;
    Two2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return new Two2(value0, value1, value22, value32);
          };
        };
      };
    };
    return Two2;
  }();
  var Three = /* @__PURE__ */ function() {
    function Three2(value0, value1, value22, value32, value42, value52, value62) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
      this.value4 = value42;
      this.value5 = value52;
      this.value6 = value62;
    }
    ;
    Three2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return function(value42) {
              return function(value52) {
                return function(value62) {
                  return new Three2(value0, value1, value22, value32, value42, value52, value62);
                };
              };
            };
          };
        };
      };
    };
    return Three2;
  }();
  var TwoLeft = /* @__PURE__ */ function() {
    function TwoLeft2(value0, value1, value22) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
    }
    ;
    TwoLeft2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return new TwoLeft2(value0, value1, value22);
        };
      };
    };
    return TwoLeft2;
  }();
  var TwoRight = /* @__PURE__ */ function() {
    function TwoRight2(value0, value1, value22) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
    }
    ;
    TwoRight2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return new TwoRight2(value0, value1, value22);
        };
      };
    };
    return TwoRight2;
  }();
  var ThreeLeft = /* @__PURE__ */ function() {
    function ThreeLeft2(value0, value1, value22, value32, value42, value52) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
      this.value4 = value42;
      this.value5 = value52;
    }
    ;
    ThreeLeft2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return function(value42) {
              return function(value52) {
                return new ThreeLeft2(value0, value1, value22, value32, value42, value52);
              };
            };
          };
        };
      };
    };
    return ThreeLeft2;
  }();
  var ThreeMiddle = /* @__PURE__ */ function() {
    function ThreeMiddle2(value0, value1, value22, value32, value42, value52) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
      this.value4 = value42;
      this.value5 = value52;
    }
    ;
    ThreeMiddle2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return function(value42) {
              return function(value52) {
                return new ThreeMiddle2(value0, value1, value22, value32, value42, value52);
              };
            };
          };
        };
      };
    };
    return ThreeMiddle2;
  }();
  var ThreeRight = /* @__PURE__ */ function() {
    function ThreeRight2(value0, value1, value22, value32, value42, value52) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
      this.value4 = value42;
      this.value5 = value52;
    }
    ;
    ThreeRight2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return function(value42) {
              return function(value52) {
                return new ThreeRight2(value0, value1, value22, value32, value42, value52);
              };
            };
          };
        };
      };
    };
    return ThreeRight2;
  }();
  var KickUp = /* @__PURE__ */ function() {
    function KickUp2(value0, value1, value22, value32) {
      this.value0 = value0;
      this.value1 = value1;
      this.value2 = value22;
      this.value3 = value32;
    }
    ;
    KickUp2.create = function(value0) {
      return function(value1) {
        return function(value22) {
          return function(value32) {
            return new KickUp2(value0, value1, value22, value32);
          };
        };
      };
    };
    return KickUp2;
  }();
  var singleton3 = function(k) {
    return function(v) {
      return new Two(Leaf.value, k, v, Leaf.value);
    };
  };
  var lookup = function(dictOrd) {
    var compare3 = compare(dictOrd);
    return function(k) {
      var go2 = function($copy_v) {
        var $tco_done = false;
        var $tco_result;
        function $tco_loop(v) {
          if (v instanceof Leaf) {
            $tco_done = true;
            return Nothing.value;
          }
          ;
          if (v instanceof Two) {
            var v2 = compare3(k)(v.value1);
            if (v2 instanceof EQ) {
              $tco_done = true;
              return new Just(v.value2);
            }
            ;
            if (v2 instanceof LT) {
              $copy_v = v.value0;
              return;
            }
            ;
            $copy_v = v.value3;
            return;
          }
          ;
          if (v instanceof Three) {
            var v3 = compare3(k)(v.value1);
            if (v3 instanceof EQ) {
              $tco_done = true;
              return new Just(v.value2);
            }
            ;
            var v4 = compare3(k)(v.value4);
            if (v4 instanceof EQ) {
              $tco_done = true;
              return new Just(v.value5);
            }
            ;
            if (v3 instanceof LT) {
              $copy_v = v.value0;
              return;
            }
            ;
            if (v4 instanceof GT) {
              $copy_v = v.value6;
              return;
            }
            ;
            $copy_v = v.value3;
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 241, column 5 - line 241, column 22): " + [v.constructor.name]);
        }
        ;
        while (!$tco_done) {
          $tco_result = $tco_loop($copy_v);
        }
        ;
        return $tco_result;
      };
      return go2;
    };
  };
  var fromZipper = function($copy_dictOrd) {
    return function($copy_v) {
      return function($copy_v1) {
        var $tco_var_dictOrd = $copy_dictOrd;
        var $tco_var_v = $copy_v;
        var $tco_done = false;
        var $tco_result;
        function $tco_loop(dictOrd, v, v1) {
          if (v instanceof Nil) {
            $tco_done = true;
            return v1;
          }
          ;
          if (v instanceof Cons) {
            if (v.value0 instanceof TwoLeft) {
              $tco_var_dictOrd = dictOrd;
              $tco_var_v = v.value1;
              $copy_v1 = new Two(v1, v.value0.value0, v.value0.value1, v.value0.value2);
              return;
            }
            ;
            if (v.value0 instanceof TwoRight) {
              $tco_var_dictOrd = dictOrd;
              $tco_var_v = v.value1;
              $copy_v1 = new Two(v.value0.value0, v.value0.value1, v.value0.value2, v1);
              return;
            }
            ;
            if (v.value0 instanceof ThreeLeft) {
              $tco_var_dictOrd = dictOrd;
              $tco_var_v = v.value1;
              $copy_v1 = new Three(v1, v.value0.value0, v.value0.value1, v.value0.value2, v.value0.value3, v.value0.value4, v.value0.value5);
              return;
            }
            ;
            if (v.value0 instanceof ThreeMiddle) {
              $tco_var_dictOrd = dictOrd;
              $tco_var_v = v.value1;
              $copy_v1 = new Three(v.value0.value0, v.value0.value1, v.value0.value2, v1, v.value0.value3, v.value0.value4, v.value0.value5);
              return;
            }
            ;
            if (v.value0 instanceof ThreeRight) {
              $tco_var_dictOrd = dictOrd;
              $tco_var_v = v.value1;
              $copy_v1 = new Three(v.value0.value0, v.value0.value1, v.value0.value2, v.value0.value3, v.value0.value4, v.value0.value5, v1);
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.Map.Internal (line 462, column 3 - line 467, column 88): " + [v.value0.constructor.name]);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 459, column 1 - line 459, column 80): " + [v.constructor.name, v1.constructor.name]);
        }
        ;
        while (!$tco_done) {
          $tco_result = $tco_loop($tco_var_dictOrd, $tco_var_v, $copy_v1);
        }
        ;
        return $tco_result;
      };
    };
  };
  var insert = function(dictOrd) {
    var fromZipper1 = fromZipper(dictOrd);
    var compare3 = compare(dictOrd);
    return function(k) {
      return function(v) {
        var up = function($copy_v1) {
          return function($copy_v2) {
            var $tco_var_v1 = $copy_v1;
            var $tco_done = false;
            var $tco_result;
            function $tco_loop(v1, v2) {
              if (v1 instanceof Nil) {
                $tco_done = true;
                return new Two(v2.value0, v2.value1, v2.value2, v2.value3);
              }
              ;
              if (v1 instanceof Cons) {
                if (v1.value0 instanceof TwoLeft) {
                  $tco_done = true;
                  return fromZipper1(v1.value1)(new Three(v2.value0, v2.value1, v2.value2, v2.value3, v1.value0.value0, v1.value0.value1, v1.value0.value2));
                }
                ;
                if (v1.value0 instanceof TwoRight) {
                  $tco_done = true;
                  return fromZipper1(v1.value1)(new Three(v1.value0.value0, v1.value0.value1, v1.value0.value2, v2.value0, v2.value1, v2.value2, v2.value3));
                }
                ;
                if (v1.value0 instanceof ThreeLeft) {
                  $tco_var_v1 = v1.value1;
                  $copy_v2 = new KickUp(new Two(v2.value0, v2.value1, v2.value2, v2.value3), v1.value0.value0, v1.value0.value1, new Two(v1.value0.value2, v1.value0.value3, v1.value0.value4, v1.value0.value5));
                  return;
                }
                ;
                if (v1.value0 instanceof ThreeMiddle) {
                  $tco_var_v1 = v1.value1;
                  $copy_v2 = new KickUp(new Two(v1.value0.value0, v1.value0.value1, v1.value0.value2, v2.value0), v2.value1, v2.value2, new Two(v2.value3, v1.value0.value3, v1.value0.value4, v1.value0.value5));
                  return;
                }
                ;
                if (v1.value0 instanceof ThreeRight) {
                  $tco_var_v1 = v1.value1;
                  $copy_v2 = new KickUp(new Two(v1.value0.value0, v1.value0.value1, v1.value0.value2, v1.value0.value3), v1.value0.value4, v1.value0.value5, new Two(v2.value0, v2.value1, v2.value2, v2.value3));
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.Map.Internal (line 498, column 5 - line 503, column 108): " + [v1.value0.constructor.name, v2.constructor.name]);
              }
              ;
              throw new Error("Failed pattern match at Data.Map.Internal (line 495, column 3 - line 495, column 56): " + [v1.constructor.name, v2.constructor.name]);
            }
            ;
            while (!$tco_done) {
              $tco_result = $tco_loop($tco_var_v1, $copy_v2);
            }
            ;
            return $tco_result;
          };
        };
        var down = function($copy_v1) {
          return function($copy_v2) {
            var $tco_var_v1 = $copy_v1;
            var $tco_done1 = false;
            var $tco_result;
            function $tco_loop(v1, v2) {
              if (v2 instanceof Leaf) {
                $tco_done1 = true;
                return up(v1)(new KickUp(Leaf.value, k, v, Leaf.value));
              }
              ;
              if (v2 instanceof Two) {
                var v3 = compare3(k)(v2.value1);
                if (v3 instanceof EQ) {
                  $tco_done1 = true;
                  return fromZipper1(v1)(new Two(v2.value0, k, v, v2.value3));
                }
                ;
                if (v3 instanceof LT) {
                  $tco_var_v1 = new Cons(new TwoLeft(v2.value1, v2.value2, v2.value3), v1);
                  $copy_v2 = v2.value0;
                  return;
                }
                ;
                $tco_var_v1 = new Cons(new TwoRight(v2.value0, v2.value1, v2.value2), v1);
                $copy_v2 = v2.value3;
                return;
              }
              ;
              if (v2 instanceof Three) {
                var v3 = compare3(k)(v2.value1);
                if (v3 instanceof EQ) {
                  $tco_done1 = true;
                  return fromZipper1(v1)(new Three(v2.value0, k, v, v2.value3, v2.value4, v2.value5, v2.value6));
                }
                ;
                var v4 = compare3(k)(v2.value4);
                if (v4 instanceof EQ) {
                  $tco_done1 = true;
                  return fromZipper1(v1)(new Three(v2.value0, v2.value1, v2.value2, v2.value3, k, v, v2.value6));
                }
                ;
                if (v3 instanceof LT) {
                  $tco_var_v1 = new Cons(new ThreeLeft(v2.value1, v2.value2, v2.value3, v2.value4, v2.value5, v2.value6), v1);
                  $copy_v2 = v2.value0;
                  return;
                }
                ;
                if (v3 instanceof GT && v4 instanceof LT) {
                  $tco_var_v1 = new Cons(new ThreeMiddle(v2.value0, v2.value1, v2.value2, v2.value4, v2.value5, v2.value6), v1);
                  $copy_v2 = v2.value3;
                  return;
                }
                ;
                $tco_var_v1 = new Cons(new ThreeRight(v2.value0, v2.value1, v2.value2, v2.value3, v2.value4, v2.value5), v1);
                $copy_v2 = v2.value6;
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.Map.Internal (line 478, column 3 - line 478, column 55): " + [v1.constructor.name, v2.constructor.name]);
            }
            ;
            while (!$tco_done1) {
              $tco_result = $tco_loop($tco_var_v1, $copy_v2);
            }
            ;
            return $tco_result;
          };
        };
        return down(Nil.value);
      };
    };
  };
  var pop = function(dictOrd) {
    var fromZipper1 = fromZipper(dictOrd);
    var compare3 = compare(dictOrd);
    return function(k) {
      var up = function($copy_ctxs) {
        return function($copy_tree) {
          var $tco_var_ctxs = $copy_ctxs;
          var $tco_done = false;
          var $tco_result;
          function $tco_loop(ctxs, tree) {
            if (ctxs instanceof Nil) {
              $tco_done = true;
              return tree;
            }
            ;
            if (ctxs instanceof Cons) {
              if (ctxs.value0 instanceof TwoLeft && (ctxs.value0.value2 instanceof Leaf && tree instanceof Leaf)) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(Leaf.value, ctxs.value0.value0, ctxs.value0.value1, Leaf.value));
              }
              ;
              if (ctxs.value0 instanceof TwoRight && (ctxs.value0.value0 instanceof Leaf && tree instanceof Leaf)) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(Leaf.value, ctxs.value0.value1, ctxs.value0.value2, Leaf.value));
              }
              ;
              if (ctxs.value0 instanceof TwoLeft && ctxs.value0.value2 instanceof Two) {
                $tco_var_ctxs = ctxs.value1;
                $copy_tree = new Three(tree, ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2.value0, ctxs.value0.value2.value1, ctxs.value0.value2.value2, ctxs.value0.value2.value3);
                return;
              }
              ;
              if (ctxs.value0 instanceof TwoRight && ctxs.value0.value0 instanceof Two) {
                $tco_var_ctxs = ctxs.value1;
                $copy_tree = new Three(ctxs.value0.value0.value0, ctxs.value0.value0.value1, ctxs.value0.value0.value2, ctxs.value0.value0.value3, ctxs.value0.value1, ctxs.value0.value2, tree);
                return;
              }
              ;
              if (ctxs.value0 instanceof TwoLeft && ctxs.value0.value2 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(new Two(tree, ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2.value0), ctxs.value0.value2.value1, ctxs.value0.value2.value2, new Two(ctxs.value0.value2.value3, ctxs.value0.value2.value4, ctxs.value0.value2.value5, ctxs.value0.value2.value6)));
              }
              ;
              if (ctxs.value0 instanceof TwoRight && ctxs.value0.value0 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(new Two(ctxs.value0.value0.value0, ctxs.value0.value0.value1, ctxs.value0.value0.value2, ctxs.value0.value0.value3), ctxs.value0.value0.value4, ctxs.value0.value0.value5, new Two(ctxs.value0.value0.value6, ctxs.value0.value1, ctxs.value0.value2, tree)));
              }
              ;
              if (ctxs.value0 instanceof ThreeLeft && (ctxs.value0.value2 instanceof Leaf && (ctxs.value0.value5 instanceof Leaf && tree instanceof Leaf))) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(Leaf.value, ctxs.value0.value0, ctxs.value0.value1, Leaf.value, ctxs.value0.value3, ctxs.value0.value4, Leaf.value));
              }
              ;
              if (ctxs.value0 instanceof ThreeMiddle && (ctxs.value0.value0 instanceof Leaf && (ctxs.value0.value5 instanceof Leaf && tree instanceof Leaf))) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(Leaf.value, ctxs.value0.value1, ctxs.value0.value2, Leaf.value, ctxs.value0.value3, ctxs.value0.value4, Leaf.value));
              }
              ;
              if (ctxs.value0 instanceof ThreeRight && (ctxs.value0.value0 instanceof Leaf && (ctxs.value0.value3 instanceof Leaf && tree instanceof Leaf))) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(Leaf.value, ctxs.value0.value1, ctxs.value0.value2, Leaf.value, ctxs.value0.value4, ctxs.value0.value5, Leaf.value));
              }
              ;
              if (ctxs.value0 instanceof ThreeLeft && ctxs.value0.value2 instanceof Two) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(new Three(tree, ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2.value0, ctxs.value0.value2.value1, ctxs.value0.value2.value2, ctxs.value0.value2.value3), ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5));
              }
              ;
              if (ctxs.value0 instanceof ThreeMiddle && ctxs.value0.value0 instanceof Two) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(new Three(ctxs.value0.value0.value0, ctxs.value0.value0.value1, ctxs.value0.value0.value2, ctxs.value0.value0.value3, ctxs.value0.value1, ctxs.value0.value2, tree), ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5));
              }
              ;
              if (ctxs.value0 instanceof ThreeMiddle && ctxs.value0.value5 instanceof Two) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2, new Three(tree, ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5.value0, ctxs.value0.value5.value1, ctxs.value0.value5.value2, ctxs.value0.value5.value3)));
              }
              ;
              if (ctxs.value0 instanceof ThreeRight && ctxs.value0.value3 instanceof Two) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Two(ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2, new Three(ctxs.value0.value3.value0, ctxs.value0.value3.value1, ctxs.value0.value3.value2, ctxs.value0.value3.value3, ctxs.value0.value4, ctxs.value0.value5, tree)));
              }
              ;
              if (ctxs.value0 instanceof ThreeLeft && ctxs.value0.value2 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(new Two(tree, ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2.value0), ctxs.value0.value2.value1, ctxs.value0.value2.value2, new Two(ctxs.value0.value2.value3, ctxs.value0.value2.value4, ctxs.value0.value2.value5, ctxs.value0.value2.value6), ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5));
              }
              ;
              if (ctxs.value0 instanceof ThreeMiddle && ctxs.value0.value0 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(new Two(ctxs.value0.value0.value0, ctxs.value0.value0.value1, ctxs.value0.value0.value2, ctxs.value0.value0.value3), ctxs.value0.value0.value4, ctxs.value0.value0.value5, new Two(ctxs.value0.value0.value6, ctxs.value0.value1, ctxs.value0.value2, tree), ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5));
              }
              ;
              if (ctxs.value0 instanceof ThreeMiddle && ctxs.value0.value5 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2, new Two(tree, ctxs.value0.value3, ctxs.value0.value4, ctxs.value0.value5.value0), ctxs.value0.value5.value1, ctxs.value0.value5.value2, new Two(ctxs.value0.value5.value3, ctxs.value0.value5.value4, ctxs.value0.value5.value5, ctxs.value0.value5.value6)));
              }
              ;
              if (ctxs.value0 instanceof ThreeRight && ctxs.value0.value3 instanceof Three) {
                $tco_done = true;
                return fromZipper1(ctxs.value1)(new Three(ctxs.value0.value0, ctxs.value0.value1, ctxs.value0.value2, new Two(ctxs.value0.value3.value0, ctxs.value0.value3.value1, ctxs.value0.value3.value2, ctxs.value0.value3.value3), ctxs.value0.value3.value4, ctxs.value0.value3.value5, new Two(ctxs.value0.value3.value6, ctxs.value0.value4, ctxs.value0.value5, tree)));
              }
              ;
              $tco_done = true;
              return unsafeCrashWith("The impossible happened in partial function `up`.");
            }
            ;
            throw new Error("Failed pattern match at Data.Map.Internal (line 552, column 5 - line 573, column 86): " + [ctxs.constructor.name]);
          }
          ;
          while (!$tco_done) {
            $tco_result = $tco_loop($tco_var_ctxs, $copy_tree);
          }
          ;
          return $tco_result;
        };
      };
      var removeMaxNode = function($copy_ctx) {
        return function($copy_m) {
          var $tco_var_ctx = $copy_ctx;
          var $tco_done1 = false;
          var $tco_result;
          function $tco_loop(ctx, m) {
            if (m instanceof Two && (m.value0 instanceof Leaf && m.value3 instanceof Leaf)) {
              $tco_done1 = true;
              return up(ctx)(Leaf.value);
            }
            ;
            if (m instanceof Two) {
              $tco_var_ctx = new Cons(new TwoRight(m.value0, m.value1, m.value2), ctx);
              $copy_m = m.value3;
              return;
            }
            ;
            if (m instanceof Three && (m.value0 instanceof Leaf && (m.value3 instanceof Leaf && m.value6 instanceof Leaf))) {
              $tco_done1 = true;
              return up(new Cons(new TwoRight(Leaf.value, m.value1, m.value2), ctx))(Leaf.value);
            }
            ;
            if (m instanceof Three) {
              $tco_var_ctx = new Cons(new ThreeRight(m.value0, m.value1, m.value2, m.value3, m.value4, m.value5), ctx);
              $copy_m = m.value6;
              return;
            }
            ;
            $tco_done1 = true;
            return unsafeCrashWith("The impossible happened in partial function `removeMaxNode`.");
          }
          ;
          while (!$tco_done1) {
            $tco_result = $tco_loop($tco_var_ctx, $copy_m);
          }
          ;
          return $tco_result;
        };
      };
      var maxNode = function($copy_m) {
        var $tco_done2 = false;
        var $tco_result;
        function $tco_loop(m) {
          if (m instanceof Two && m.value3 instanceof Leaf) {
            $tco_done2 = true;
            return {
              key: m.value1,
              value: m.value2
            };
          }
          ;
          if (m instanceof Two) {
            $copy_m = m.value3;
            return;
          }
          ;
          if (m instanceof Three && m.value6 instanceof Leaf) {
            $tco_done2 = true;
            return {
              key: m.value4,
              value: m.value5
            };
          }
          ;
          if (m instanceof Three) {
            $copy_m = m.value6;
            return;
          }
          ;
          $tco_done2 = true;
          return unsafeCrashWith("The impossible happened in partial function `maxNode`.");
        }
        ;
        while (!$tco_done2) {
          $tco_result = $tco_loop($copy_m);
        }
        ;
        return $tco_result;
      };
      var down = function($copy_ctx) {
        return function($copy_m) {
          var $tco_var_ctx = $copy_ctx;
          var $tco_done3 = false;
          var $tco_result;
          function $tco_loop(ctx, m) {
            if (m instanceof Leaf) {
              $tco_done3 = true;
              return Nothing.value;
            }
            ;
            if (m instanceof Two) {
              var v = compare3(k)(m.value1);
              if (m.value3 instanceof Leaf && v instanceof EQ) {
                $tco_done3 = true;
                return new Just(new Tuple(m.value2, up(ctx)(Leaf.value)));
              }
              ;
              if (v instanceof EQ) {
                var max6 = maxNode(m.value0);
                $tco_done3 = true;
                return new Just(new Tuple(m.value2, removeMaxNode(new Cons(new TwoLeft(max6.key, max6.value, m.value3), ctx))(m.value0)));
              }
              ;
              if (v instanceof LT) {
                $tco_var_ctx = new Cons(new TwoLeft(m.value1, m.value2, m.value3), ctx);
                $copy_m = m.value0;
                return;
              }
              ;
              $tco_var_ctx = new Cons(new TwoRight(m.value0, m.value1, m.value2), ctx);
              $copy_m = m.value3;
              return;
            }
            ;
            if (m instanceof Three) {
              var leaves = function() {
                if (m.value0 instanceof Leaf && (m.value3 instanceof Leaf && m.value6 instanceof Leaf)) {
                  return true;
                }
                ;
                return false;
              }();
              var v = compare3(k)(m.value4);
              var v3 = compare3(k)(m.value1);
              if (leaves && v3 instanceof EQ) {
                $tco_done3 = true;
                return new Just(new Tuple(m.value2, fromZipper1(ctx)(new Two(Leaf.value, m.value4, m.value5, Leaf.value))));
              }
              ;
              if (leaves && v instanceof EQ) {
                $tco_done3 = true;
                return new Just(new Tuple(m.value5, fromZipper1(ctx)(new Two(Leaf.value, m.value1, m.value2, Leaf.value))));
              }
              ;
              if (v3 instanceof EQ) {
                var max6 = maxNode(m.value0);
                $tco_done3 = true;
                return new Just(new Tuple(m.value2, removeMaxNode(new Cons(new ThreeLeft(max6.key, max6.value, m.value3, m.value4, m.value5, m.value6), ctx))(m.value0)));
              }
              ;
              if (v instanceof EQ) {
                var max6 = maxNode(m.value3);
                $tco_done3 = true;
                return new Just(new Tuple(m.value5, removeMaxNode(new Cons(new ThreeMiddle(m.value0, m.value1, m.value2, max6.key, max6.value, m.value6), ctx))(m.value3)));
              }
              ;
              if (v3 instanceof LT) {
                $tco_var_ctx = new Cons(new ThreeLeft(m.value1, m.value2, m.value3, m.value4, m.value5, m.value6), ctx);
                $copy_m = m.value0;
                return;
              }
              ;
              if (v3 instanceof GT && v instanceof LT) {
                $tco_var_ctx = new Cons(new ThreeMiddle(m.value0, m.value1, m.value2, m.value4, m.value5, m.value6), ctx);
                $copy_m = m.value3;
                return;
              }
              ;
              $tco_var_ctx = new Cons(new ThreeRight(m.value0, m.value1, m.value2, m.value3, m.value4, m.value5), ctx);
              $copy_m = m.value6;
              return;
            }
            ;
            throw new Error("Failed pattern match at Data.Map.Internal (line 525, column 16 - line 548, column 80): " + [m.constructor.name]);
          }
          ;
          while (!$tco_done3) {
            $tco_result = $tco_loop($tco_var_ctx, $copy_m);
          }
          ;
          return $tco_result;
        };
      };
      return down(Nil.value);
    };
  };
  var foldableMap = {
    foldr: function(f) {
      return function(z) {
        return function(m) {
          if (m instanceof Leaf) {
            return z;
          }
          ;
          if (m instanceof Two) {
            return foldr(foldableMap)(f)(f(m.value2)(foldr(foldableMap)(f)(z)(m.value3)))(m.value0);
          }
          ;
          if (m instanceof Three) {
            return foldr(foldableMap)(f)(f(m.value2)(foldr(foldableMap)(f)(f(m.value5)(foldr(foldableMap)(f)(z)(m.value6)))(m.value3)))(m.value0);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 133, column 17 - line 136, column 85): " + [m.constructor.name]);
        };
      };
    },
    foldl: function(f) {
      return function(z) {
        return function(m) {
          if (m instanceof Leaf) {
            return z;
          }
          ;
          if (m instanceof Two) {
            return foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(z)(m.value0))(m.value2))(m.value3);
          }
          ;
          if (m instanceof Three) {
            return foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(f(foldl(foldableMap)(f)(z)(m.value0))(m.value2))(m.value3))(m.value5))(m.value6);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 137, column 17 - line 140, column 85): " + [m.constructor.name]);
        };
      };
    },
    foldMap: function(dictMonoid) {
      var mempty5 = mempty(dictMonoid);
      var append22 = append(dictMonoid.Semigroup0());
      return function(f) {
        return function(m) {
          if (m instanceof Leaf) {
            return mempty5;
          }
          ;
          if (m instanceof Two) {
            return append22(foldMap(foldableMap)(dictMonoid)(f)(m.value0))(append22(f(m.value2))(foldMap(foldableMap)(dictMonoid)(f)(m.value3)));
          }
          ;
          if (m instanceof Three) {
            return append22(foldMap(foldableMap)(dictMonoid)(f)(m.value0))(append22(f(m.value2))(append22(foldMap(foldableMap)(dictMonoid)(f)(m.value3))(append22(f(m.value5))(foldMap(foldableMap)(dictMonoid)(f)(m.value6)))));
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 141, column 17 - line 144, column 93): " + [m.constructor.name]);
        };
      };
    }
  };
  var foldableWithIndexMap = {
    foldrWithIndex: function(f) {
      return function(z) {
        return function(m) {
          if (m instanceof Leaf) {
            return z;
          }
          ;
          if (m instanceof Two) {
            return foldrWithIndex(foldableWithIndexMap)(f)(f(m.value1)(m.value2)(foldrWithIndex(foldableWithIndexMap)(f)(z)(m.value3)))(m.value0);
          }
          ;
          if (m instanceof Three) {
            return foldrWithIndex(foldableWithIndexMap)(f)(f(m.value1)(m.value2)(foldrWithIndex(foldableWithIndexMap)(f)(f(m.value4)(m.value5)(foldrWithIndex(foldableWithIndexMap)(f)(z)(m.value6)))(m.value3)))(m.value0);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 147, column 26 - line 150, column 120): " + [m.constructor.name]);
        };
      };
    },
    foldlWithIndex: function(f) {
      return function(z) {
        return function(m) {
          if (m instanceof Leaf) {
            return z;
          }
          ;
          if (m instanceof Two) {
            return foldlWithIndex(foldableWithIndexMap)(f)(f(m.value1)(foldlWithIndex(foldableWithIndexMap)(f)(z)(m.value0))(m.value2))(m.value3);
          }
          ;
          if (m instanceof Three) {
            return foldlWithIndex(foldableWithIndexMap)(f)(f(m.value4)(foldlWithIndex(foldableWithIndexMap)(f)(f(m.value1)(foldlWithIndex(foldableWithIndexMap)(f)(z)(m.value0))(m.value2))(m.value3))(m.value5))(m.value6);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 151, column 26 - line 154, column 120): " + [m.constructor.name]);
        };
      };
    },
    foldMapWithIndex: function(dictMonoid) {
      var mempty5 = mempty(dictMonoid);
      var append22 = append(dictMonoid.Semigroup0());
      return function(f) {
        return function(m) {
          if (m instanceof Leaf) {
            return mempty5;
          }
          ;
          if (m instanceof Two) {
            return append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value0))(append22(f(m.value1)(m.value2))(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value3)));
          }
          ;
          if (m instanceof Three) {
            return append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value0))(append22(f(m.value1)(m.value2))(append22(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value3))(append22(f(m.value4)(m.value5))(foldMapWithIndex(foldableWithIndexMap)(dictMonoid)(f)(m.value6)))));
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 155, column 26 - line 158, column 128): " + [m.constructor.name]);
        };
      };
    },
    Foldable0: function() {
      return foldableMap;
    }
  };
  var foldrWithIndex2 = /* @__PURE__ */ foldrWithIndex(foldableWithIndexMap);
  var foldlWithIndex2 = /* @__PURE__ */ foldlWithIndex(foldableWithIndexMap);
  var keys = /* @__PURE__ */ function() {
    return foldrWithIndex2(function(k) {
      return function(v) {
        return function(acc) {
          return new Cons(k, acc);
        };
      };
    })(Nil.value);
  }();
  var empty2 = /* @__PURE__ */ function() {
    return Leaf.value;
  }();
  var $$delete = function(dictOrd) {
    var pop1 = pop(dictOrd);
    return function(k) {
      return function(m) {
        return maybe(m)(snd)(pop1(k)(m));
      };
    };
  };
  var alter = function(dictOrd) {
    var lookup1 = lookup(dictOrd);
    var delete1 = $$delete(dictOrd);
    var insert1 = insert(dictOrd);
    return function(f) {
      return function(k) {
        return function(m) {
          var v = f(lookup1(k)(m));
          if (v instanceof Nothing) {
            return delete1(k)(m);
          }
          ;
          if (v instanceof Just) {
            return insert1(k)(v.value0)(m);
          }
          ;
          throw new Error("Failed pattern match at Data.Map.Internal (line 596, column 15 - line 598, column 25): " + [v.constructor.name]);
        };
      };
    };
  };
  var unionWith = function(dictOrd) {
    var alter1 = alter(dictOrd);
    return function(f) {
      return function(m1) {
        return function(m2) {
          var go2 = function(k) {
            return function(m) {
              return function(v) {
                return alter1(function() {
                  var $936 = maybe(v)(f(v));
                  return function($937) {
                    return Just.create($936($937));
                  };
                }())(k)(m);
              };
            };
          };
          return foldlWithIndex2(go2)(m2)(m1);
        };
      };
    };
  };
  var union = function(dictOrd) {
    return unionWith(dictOrd)($$const);
  };

  // output/Data.Filterable/index.js
  var filterMap = function(dict) {
    return dict.filterMap;
  };
  var filter4 = function(dict) {
    return dict.filter;
  };

  // output/Data.Set/index.js
  var foldMap2 = /* @__PURE__ */ foldMap(foldableList);
  var foldl2 = /* @__PURE__ */ foldl(foldableList);
  var foldr2 = /* @__PURE__ */ foldr(foldableList);
  var union2 = function(dictOrd) {
    var union1 = union(dictOrd);
    return function(v) {
      return function(v1) {
        return union1(v)(v1);
      };
    };
  };
  var toList = function(v) {
    return keys(v);
  };
  var singleton4 = function(a2) {
    return singleton3(a2)(unit);
  };
  var semigroupSet = function(dictOrd) {
    return {
      append: union2(dictOrd)
    };
  };
  var foldableSet = {
    foldMap: function(dictMonoid) {
      var foldMap12 = foldMap2(dictMonoid);
      return function(f) {
        var $129 = foldMap12(f);
        return function($130) {
          return $129(toList($130));
        };
      };
    },
    foldl: function(f) {
      return function(x) {
        var $131 = foldl2(f)(x);
        return function($132) {
          return $131(toList($132));
        };
      };
    },
    foldr: function(f) {
      return function(x) {
        var $133 = foldr2(f)(x);
        return function($134) {
          return $133(toList($134));
        };
      };
    }
  };
  var empty3 = empty2;
  var monoidSet = function(dictOrd) {
    var semigroupSet1 = semigroupSet(dictOrd);
    return {
      mempty: empty3,
      Semigroup0: function() {
        return semigroupSet1;
      }
    };
  };
  var $$delete2 = function(dictOrd) {
    var delete1 = $$delete(dictOrd);
    return function(a2) {
      return function(v) {
        return delete1(a2)(v);
      };
    };
  };

  // output/Effect.Timer/foreign.js
  function setTimeoutImpl(ms) {
    return function(fn) {
      return function() {
        return setTimeout(fn, ms);
      };
    };
  }
  function clearTimeoutImpl(id) {
    return function() {
      clearTimeout(id);
    };
  }

  // output/Effect.Timer/index.js
  var compare2 = /* @__PURE__ */ compare(ordInt);
  var setTimeout2 = setTimeoutImpl;
  var eqTimeoutId = {
    eq: function(x) {
      return function(y) {
        return x === y;
      };
    }
  };
  var ordTimeoutId = {
    compare: function(x) {
      return function(y) {
        return compare2(x)(y);
      };
    },
    Eq0: function() {
      return eqTimeoutId;
    }
  };
  var clearTimeout2 = clearTimeoutImpl;

  // output/Effect.Uncurried/foreign.js
  var mkEffectFn1 = function mkEffectFn12(fn) {
    return function(x) {
      return fn(x)();
    };
  };
  var runEffectFn1 = function runEffectFn12(fn) {
    return function(a2) {
      return function() {
        return fn(a2);
      };
    };
  };

  // output/Effect.Uncurried/index.js
  var semigroupEffectFn1 = function(dictSemigroup) {
    var append7 = append(semigroupEffect(dictSemigroup));
    return {
      append: function(f1) {
        return function(f2) {
          return mkEffectFn1(function(a2) {
            return append7(runEffectFn1(f1)(a2))(runEffectFn1(f2)(a2));
          });
        };
      }
    };
  };
  var monoidEffectFn1 = function(dictMonoid) {
    var mempty5 = mempty(monoidEffect(dictMonoid));
    var semigroupEffectFn11 = semigroupEffectFn1(dictMonoid.Semigroup0());
    return {
      mempty: mkEffectFn1(function(v) {
        return mempty5;
      }),
      Semigroup0: function() {
        return semigroupEffectFn11;
      }
    };
  };

  // output/FRP.Event.Class/index.js
  var map3 = /* @__PURE__ */ map(functorTuple);
  var pure3 = /* @__PURE__ */ pure(applicativeMaybe);
  var sampleOnRight = function(dict) {
    return dict.sampleOnRight;
  };
  var keepLatest = function(dict) {
    return dict.keepLatest;
  };
  var fix2 = function(dict) {
    return dict.fix;
  };
  var fold2 = function(dictIsEvent) {
    var fix1 = fix2(dictIsEvent);
    var sampleOnRight1 = sampleOnRight(dictIsEvent);
    var Alternative0 = dictIsEvent.Alternative0();
    var alt7 = alt(Alternative0.Plus1().Alt0());
    var pure15 = pure(Alternative0.Applicative0());
    var map18 = map(dictIsEvent.Filterable1().Functor1());
    return function(f) {
      return function(b2) {
        return function(e) {
          return fix1(function(i2) {
            return sampleOnRight1(alt7(i2)(pure15(b2)))(map18(flip(f))(e));
          });
        };
      };
    };
  };
  var mapAccum = function(dictIsEvent) {
    var filterMap2 = filterMap(dictIsEvent.Filterable1());
    var fold12 = fold2(dictIsEvent);
    return function(f) {
      return function(acc) {
        return function(xs) {
          return filterMap2(snd)(fold12(function(v) {
            return function(b2) {
              return map3(pure3)(f(v.value0)(b2));
            };
          })(new Tuple(acc, Nothing.value))(xs));
        };
      };
    };
  };

  // output/Unsafe.Reference/foreign.js
  function reallyUnsafeRefEq(a2) {
    return function(b2) {
      return a2 === b2;
    };
  }

  // output/Unsafe.Reference/index.js
  var unsafeRefEq = reallyUnsafeRefEq;

  // output/FRP.Event/index.js
  var $runtime_lazy3 = function(name15, moduleName, init2) {
    var state4 = 0;
    var val;
    return function(lineNumber) {
      if (state4 === 2)
        return val;
      if (state4 === 1)
        throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state4 = 1;
      val = init2();
      state4 = 2;
      return val;
    };
  };
  var for_2 = /* @__PURE__ */ for_(applicativeEffect);
  var for_1 = /* @__PURE__ */ for_2(foldableMaybe);
  var pure4 = /* @__PURE__ */ pure(applicativeEffect);
  var liftST2 = /* @__PURE__ */ liftST(monadSTEffect);
  var monoidEffect2 = /* @__PURE__ */ monoidEffect(monoidUnit);
  var $$void3 = /* @__PURE__ */ $$void(functorEffect);
  var append2 = /* @__PURE__ */ append(semigroupArray);
  var mempty2 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidEffectFn1(monoidUnit));
  var mempty1 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidSet(ordTimeoutId));
  var $$delete3 = /* @__PURE__ */ $$delete2(ordTimeoutId);
  var append1 = /* @__PURE__ */ append(/* @__PURE__ */ semigroupSet(ordTimeoutId));
  var for_22 = /* @__PURE__ */ for_2(foldableSet);
  var apply2 = /* @__PURE__ */ apply(applyEffect);
  var map4 = /* @__PURE__ */ map(functorEffect);
  var sampleOnRight2 = function(v) {
    return function(v1) {
      return function(b2, k) {
        var latest = $$new(Nothing.value)();
        var c1 = v(b2, function(a2) {
          return write2(new Just(a2))(latest)();
        });
        var c2 = v1(b2, function(f) {
          var o = read2(latest)();
          return for_1(o)(function(a2) {
            return function() {
              return k(f(a2));
            };
          })();
        });
        return function __do2() {
          c1();
          return c2();
        };
      };
    };
  };
  var sampleOnLeft = function(v) {
    return function(v1) {
      return function(b2, k) {
        var latest = $$new(Nothing.value)();
        var c1 = v(b2, function(a2) {
          var o = read2(latest)();
          return for_1(o)(function(f) {
            return function() {
              return k(f(a2));
            };
          })();
        });
        var c2 = v1(b2, function(f) {
          return write2(new Just(f))(latest)();
        });
        return function __do2() {
          c1();
          return c2();
        };
      };
    };
  };
  var merge = function(dictFoldable) {
    var foldMap4 = foldMap(dictFoldable)(monoidEffect2);
    return function(f) {
      return function(tf, k) {
        var a2 = liftST2(newSTArray)();
        foldMap4(function(v) {
          return function __do2() {
            var u2 = v(tf, k);
            return $$void3(liftST2(push(u2)(a2)))();
          };
        })(f)();
        return function __do2() {
          var o = liftST2(freeze(a2))();
          return fastForeachThunk(o);
        };
      };
    };
  };
  var mailbox$prime = function(dictOrd) {
    var alter2 = alter(dictOrd);
    var lookup2 = lookup(dictOrd);
    return function __do2() {
      var r = $$new(empty2)();
      return {
        event: function(a2) {
          return function(v, k2) {
            $$void3(modify(alter2(function(v1) {
              if (v1 instanceof Nothing) {
                return new Just([k2]);
              }
              ;
              if (v1 instanceof Just) {
                return new Just(append2(v1.value0)([k2]));
              }
              ;
              throw new Error("Failed pattern match at FRP.Event (line 568, column 17 - line 570, column 51): " + [v1.constructor.name]);
            })(a2))(r))();
            return $$void3(modify(alter2(function(v1) {
              if (v1 instanceof Nothing) {
                return Nothing.value;
              }
              ;
              if (v1 instanceof Just) {
                return new Just(deleteBy(unsafeRefEq)(k2)(v1.value0));
              }
              ;
              throw new Error("Failed pattern match at FRP.Event (line 577, column 17 - line 579, column 65): " + [v1.constructor.name]);
            })(a2))(r));
          };
        },
        push: function(v) {
          var o = read2(r)();
          var v1 = lookup2(v.address)(o);
          if (v1 instanceof Nothing) {
            return unit;
          }
          ;
          if (v1 instanceof Just) {
            return fastForeachE(v1.value0, function(i2) {
              return i2(v.payload);
            });
          }
          ;
          throw new Error("Failed pattern match at FRP.Event (line 586, column 9 - line 588, column 95): " + [v1.constructor.name]);
        }
      };
    };
  };
  var keepLatest2 = function(v) {
    return function(tf, k) {
      var cancelInner = $$new(pure4(unit))();
      var cancelOuter = v(tf, function(v1) {
        var ci = read2(cancelInner)();
        ci();
        var c = v1(tf, k);
        return write2(c)(cancelInner)();
      });
      return function __do2() {
        var ci = read2(cancelInner)();
        ci();
        return cancelOuter();
      };
    };
  };
  var functorEvent = {
    map: function(f) {
      return function(v) {
        return function(b2, k) {
          return v(b2, function(a2) {
            return k(f(a2));
          });
        };
      };
    }
  };
  var map1 = /* @__PURE__ */ map(functorEvent);
  var filter5 = function(p2) {
    return function(v) {
      return function(tf, k) {
        return v(tf, function(a2) {
          var v1 = p2(a2);
          if (v1 instanceof Just) {
            return k(v1.value0);
          }
          ;
          if (v1 instanceof Nothing) {
            return unit;
          }
          ;
          throw new Error("Failed pattern match at FRP.Event (line 225, column 31 - line 227, column 35): " + [v1.constructor.name]);
        });
      };
    };
  };
  var filter$prime = function(f) {
    return filter5(function(a2) {
      var v = f(a2);
      if (v) {
        return new Just(a2);
      }
      ;
      if (!v) {
        return Nothing.value;
      }
      ;
      throw new Error("Failed pattern match at FRP.Event (line 141, column 13 - line 143, column 25): " + [v.constructor.name]);
    });
  };
  var create$prime = function __do() {
    var subscribers = objHack();
    var idx = $$new(0)();
    return {
      event: function(v, k) {
        var rk = $$new(k)();
        var ix = read2(idx)();
        insertObjHack(ix, rk, subscribers);
        modify_(function(v1) {
          return v1 + 1 | 0;
        })(idx)();
        return function __do2() {
          write2(mempty2)(rk)();
          deleteObjHack(ix, subscribers);
          return unit;
        };
      },
      push: function(a2) {
        return fastForeachOhE(subscribers, function(rk) {
          var k = read2(rk)();
          return k(a2);
        });
      }
    };
  };
  var fix3 = function(f) {
    return function(tf, k) {
      var v = create$prime();
      var v1 = f(v.event);
      var c2 = v.event(tf, k);
      var c1 = v1(tf, v.push);
      return function __do2() {
        c1();
        return c2();
      };
    };
  };
  var compactableEvent = {
    compact: /* @__PURE__ */ filter5(/* @__PURE__ */ identity(categoryFn)),
    separate: function(xs) {
      return {
        left: filter5(function(v) {
          if (v instanceof Left) {
            return new Just(v.value0);
          }
          ;
          if (v instanceof Right) {
            return Nothing.value;
          }
          ;
          throw new Error("Failed pattern match at FRP.Event (line 124, column 13 - line 126, column 33): " + [v.constructor.name]);
        })(xs),
        right: filter5(function(v) {
          if (v instanceof Right) {
            return new Just(v.value0);
          }
          ;
          if (v instanceof Left) {
            return Nothing.value;
          }
          ;
          throw new Error("Failed pattern match at FRP.Event (line 131, column 13 - line 133, column 32): " + [v.constructor.name]);
        })(xs)
      };
    }
  };
  var filterableEvent = {
    filter: filter$prime,
    filterMap: filter5,
    partition: function(p2) {
      return function(xs) {
        return {
          yes: filter$prime(p2)(xs),
          no: filter$prime(function($232) {
            return !p2($232);
          })(xs)
        };
      };
    },
    partitionMap: function(f) {
      return function(xs) {
        return {
          left: filterMap(filterableEvent)(function() {
            var $233 = either(Just.create)($$const(Nothing.value));
            return function($234) {
              return $233(f($234));
            };
          }())(xs),
          right: filterMap(filterableEvent)(function($235) {
            return hush(f($235));
          })(xs)
        };
      };
    },
    Compactable0: function() {
      return compactableEvent;
    },
    Functor1: function() {
      return functorEvent;
    }
  };
  var biSampleOn = function(v) {
    return function(v1) {
      return function(tf, k) {
        var latest1 = $$new(Nothing.value)();
        var replay1 = liftST2(newSTArray)();
        var latest2 = $$new(Nothing.value)();
        var replay2 = liftST2(newSTArray)();
        var capturing = $$new(true)();
        var c1 = v(tf, function(a2) {
          var o = read2(capturing)();
          if (o) {
            return $$void3(liftST2(push(a2)(replay1)))();
          }
          ;
          write2(new Just(a2))(latest1)();
          var res = read2(latest2)();
          return for_1(res)(function(f) {
            return function() {
              return k(f(a2));
            };
          })();
        });
        var c2 = v1(tf, function(f) {
          var o = read2(capturing)();
          if (o) {
            return $$void3(liftST2(push(f)(replay2)))();
          }
          ;
          write2(new Just(f))(latest2)();
          var res = read2(latest1)();
          return for_1(res)(function(a2) {
            return function() {
              return k(f(a2));
            };
          })();
        });
        write2(false)(capturing)();
        var samples1 = liftST2(freeze(replay1))();
        var samples2 = liftST2(freeze(replay2))();
        (function() {
          if (samples1.length === 0) {
            return write2(last(samples2))(latest2)();
          }
          ;
          return fastForeachE(samples1, function(a2) {
            write2(new Just(a2))(latest1)();
            return fastForeachE(samples2, function(f) {
              write2(new Just(f))(latest2)();
              return k(f(a2));
            });
          });
        })();
        liftST2(splice(0)(length(samples1))([])(replay1))();
        liftST2(splice(0)(length(samples2))([])(replay2))();
        return function __do2() {
          c1();
          return c2();
        };
      };
    };
  };
  var subscribe = function(i2) {
    return function(v) {
      return v;
    }($lazy_backdoor(345).subscribe)(i2);
  };
  var $lazy_backdoor = /* @__PURE__ */ $runtime_lazy3("backdoor", "FRP.Event", function() {
    var create_ = function __do2() {
      var subscribers = objHack();
      var idx = $$new(0)();
      return {
        event: function(v, k) {
          var rk = $$new(k)();
          var ix = read2(idx)();
          insertObjHack(ix, rk, subscribers);
          modify_(function(v1) {
            return v1 + 1 | 0;
          })(idx)();
          return function __do3() {
            write2(mempty2)(rk)();
            deleteObjHack(ix, subscribers);
            return unit;
          };
        },
        push: function(a2) {
          return function() {
            return fastForeachOhE(subscribers, function(rk) {
              var k = read2(rk)();
              return k(a2);
            });
          };
        }
      };
    };
    return {
      createO: create$prime,
      makeEvent: function() {
        var makeEvent_ = function(e) {
          return function(tf, k) {
            if (tf) {
              return pure4(unit);
            }
            ;
            return e(function(a2) {
              return function() {
                return k(a2);
              };
            })();
          };
        };
        return makeEvent_;
      }(),
      makeEventO: function() {
        var makeEventO_ = function(e) {
          return function(tf, k) {
            if (tf) {
              return pure4(unit);
            }
            ;
            return e(k);
          };
        };
        return makeEventO_;
      }(),
      makePureEvent: function() {
        var makePureEvent_ = function(e) {
          return function(v, k) {
            return e(function(a2) {
              return function() {
                return k(a2);
              };
            })();
          };
        };
        return makePureEvent_;
      }(),
      makeLemmingEvent: function() {
        var makeLemmingEvent_ = function(e) {
          return function(tf, k) {
            var o = function(v) {
              return function(kx) {
                return function() {
                  return v(tf, mkEffectFn1(kx));
                };
              };
            };
            return e(o)(function(a2) {
              return function() {
                return k(a2);
              };
            })();
          };
        };
        return makeLemmingEvent_;
      }(),
      makeLemmingEventO: function() {
        var makeLemmingEventO_ = function(e) {
          return function(tf, k) {
            var o = function(v, kx) {
              return v(tf, kx);
            };
            return e(o, k);
          };
        };
        return makeLemmingEventO_;
      }(),
      create: create_,
      createPure: create_,
      createPureO: create$prime,
      subscribe: function() {
        var subscribe_ = function(v) {
          return function(k) {
            return function() {
              return v(false, mkEffectFn1(k));
            };
          };
        };
        return subscribe_;
      }(),
      subscribeO: function() {
        var subscribeO_ = function(v, k) {
          return v(false, k);
        };
        return subscribeO_;
      }(),
      subscribePureO: function() {
        var subscribePureO_ = function(v, k) {
          return v(true, k);
        };
        return subscribePureO_;
      }(),
      subscribePure: function() {
        var subscribePure_ = function() {
          var o = function(v) {
            return function(k) {
              return function() {
                return v(true, mkEffectFn1(k));
              };
            };
          };
          return o;
        }();
        return subscribePure_;
      }(),
      bus: function() {
        var bus_ = function(f) {
          return function(v, k) {
            var v1 = $lazy_create(819)();
            k(f(v1.push)(v1.event));
            return pure4(unit);
          };
        };
        return bus_;
      }(),
      memoize: function() {
        var memoize_ = function(v) {
          return function(f) {
            return function(b2, k) {
              var v1 = create$prime();
              k(f(v1.event));
              return v(b2, v1.push);
            };
          };
        };
        return memoize_;
      }(),
      hot: function() {
        var hot_ = function(e) {
          return function __do2() {
            var v = $lazy_create(837)();
            var unsubscribe = subscribe(e)(v.push)();
            return {
              event: v.event,
              unsubscribe
            };
          };
        };
        return hot_;
      }(),
      mailbox: function() {
        var mailbox_ = function(dictOrd) {
          return function __do2() {
            var v = mailbox$prime(dictOrd)();
            return {
              event: v.event,
              push: function(k) {
                return function() {
                  return v.push(k);
                };
              }
            };
          };
        };
        return mailbox_;
      }(),
      mailboxed: function() {
        var mailboxed_ = function(dictOrd) {
          var mailbox$prime1 = mailbox$prime(dictOrd);
          return function(v) {
            return function(f) {
              return function(b2, k) {
                var v1 = mailbox$prime1();
                k(f(v1.event));
                return v(b2, v1.push);
              };
            };
          };
        };
        return mailboxed_;
      }(),
      delay: function() {
        var delay_ = function(n) {
          return function(v) {
            return function(tf, k) {
              var tid = $$new(mempty1)();
              var canceler = v(tf, function(a2) {
                var localId = $$new(Nothing.value)();
                var id = setTimeout2(n)(function __do2() {
                  k(a2);
                  var lid = read2(localId)();
                  return maybe(pure4(unit))(function(id2) {
                    return modify_($$delete3(id2))(tid);
                  })(lid)();
                })();
                write2(new Just(id))(localId)();
                return modify_(append1(singleton4(id)))(tid)();
              });
              return function __do2() {
                var ids = read2(tid)();
                for_22(ids)(clearTimeout2)();
                return canceler();
              };
            };
          };
        };
        return delay_;
      }()
    };
  });
  var $lazy_create = /* @__PURE__ */ $runtime_lazy3("create", "FRP.Event", function() {
    return function __do2() {
      unit;
      return function(v) {
        return v;
      }($lazy_backdoor(461).create)();
    };
  });
  var backdoor = /* @__PURE__ */ $lazy_backdoor(678);
  var bus = function(i2) {
    return function(v) {
      return v;
    }(backdoor.bus)(i2);
  };
  var makeEvent = function(i2) {
    return function(v) {
      return v;
    }(backdoor.makeEvent)(i2);
  };
  var makeLemmingEventO = function(i2) {
    return function(v) {
      return v;
    }(backdoor.makeLemmingEventO)(i2);
  };
  var memoize = function(i2) {
    return function(v) {
      return v;
    }(backdoor.memoize)(i2);
  };
  var applyEvent = {
    apply: function(a2) {
      return function(b2) {
        return biSampleOn(a2)(map1(applyFlipped)(b2));
      };
    },
    Functor0: function() {
      return functorEvent;
    }
  };
  var lift24 = /* @__PURE__ */ lift2(applyEvent);
  var semigroupEvent = function(dictSemigroup) {
    return {
      append: lift24(append(dictSemigroup))
    };
  };
  var applicativeEvent = {
    pure: function(a2) {
      return function(v, k) {
        k(a2);
        return pure4(unit);
      };
    },
    Apply0: function() {
      return applyEvent;
    }
  };
  var pure22 = /* @__PURE__ */ pure(applicativeEvent);
  var monoidEvent = function(dictMonoid) {
    var semigroupEvent1 = semigroupEvent(dictMonoid.Semigroup0());
    return {
      mempty: pure22(mempty(dictMonoid)),
      Semigroup0: function() {
        return semigroupEvent1;
      }
    };
  };
  var altEvent = {
    alt: function(v) {
      return function(v1) {
        return function(tf, k) {
          return apply2(map4(function(v2) {
            return function(v3) {
              return function __do2() {
                v2();
                return v3();
              };
            };
          })(function() {
            return v(tf, k);
          }))(function() {
            return v1(tf, k);
          })();
        };
      };
    },
    Functor0: function() {
      return functorEvent;
    }
  };
  var plusEvent = {
    empty: function(v, v1) {
      return pure4(unit);
    },
    Alt0: function() {
      return altEvent;
    }
  };
  var alternativeEvent = {
    Applicative0: function() {
      return applicativeEvent;
    },
    Plus1: function() {
      return plusEvent;
    }
  };
  var eventIsEvent = {
    keepLatest: keepLatest2,
    sampleOnRight: sampleOnRight2,
    sampleOnLeft,
    fix: fix3,
    Alternative0: function() {
      return alternativeEvent;
    },
    Filterable1: function() {
      return filterableEvent;
    }
  };

  // output/Bolson.Core/index.js
  var Local = /* @__PURE__ */ function() {
    function Local2(value0) {
      this.value0 = value0;
    }
    ;
    Local2.create = function(value0) {
      return new Local2(value0);
    };
    return Local2;
  }();
  var Global = /* @__PURE__ */ function() {
    function Global2() {
    }
    ;
    Global2.value = new Global2();
    return Global2;
  }();
  var Insert = /* @__PURE__ */ function() {
    function Insert2(value0) {
      this.value0 = value0;
    }
    ;
    Insert2.create = function(value0) {
      return new Insert2(value0);
    };
    return Insert2;
  }();
  var Remove = /* @__PURE__ */ function() {
    function Remove2() {
    }
    ;
    Remove2.value = new Remove2();
    return Remove2;
  }();
  var Logic = /* @__PURE__ */ function() {
    function Logic2(value0) {
      this.value0 = value0;
    }
    ;
    Logic2.create = function(value0) {
      return new Logic2(value0);
    };
    return Logic2;
  }();
  var DynamicChildren$prime = /* @__PURE__ */ function() {
    function DynamicChildren$prime2(value0) {
      this.value0 = value0;
    }
    ;
    DynamicChildren$prime2.create = function(value0) {
      return new DynamicChildren$prime2(value0);
    };
    return DynamicChildren$prime2;
  }();
  var FixedChildren$prime = /* @__PURE__ */ function() {
    function FixedChildren$prime2(value0) {
      this.value0 = value0;
    }
    ;
    FixedChildren$prime2.create = function(value0) {
      return new FixedChildren$prime2(value0);
    };
    return FixedChildren$prime2;
  }();
  var EventfulElement$prime = /* @__PURE__ */ function() {
    function EventfulElement$prime2(value0) {
      this.value0 = value0;
    }
    ;
    EventfulElement$prime2.create = function(value0) {
      return new EventfulElement$prime2(value0);
    };
    return EventfulElement$prime2;
  }();
  var Element$prime = /* @__PURE__ */ function() {
    function Element$prime2(value0) {
      this.value0 = value0;
    }
    ;
    Element$prime2.create = function(value0) {
      return new Element$prime2(value0);
    };
    return Element$prime2;
  }();
  var eqScope = {
    eq: function(x) {
      return function(y) {
        if (x instanceof Local && y instanceof Local) {
          return x.value0 === y.value0;
        }
        ;
        if (x instanceof Global && y instanceof Global) {
          return true;
        }
        ;
        return false;
      };
    }
  };
  var fixed = function(a2) {
    return new FixedChildren$prime(a2);
  };
  var envy = function(a2) {
    return new EventfulElement$prime(a2);
  };
  var dyn = function(a2) {
    return new DynamicChildren$prime(a2);
  };

  // output/Data.Array.NonEmpty.Internal/foreign.js
  var traverse1Impl = function() {
    function Cont(fn) {
      this.fn = fn;
    }
    var emptyList = {};
    var ConsCell = function(head5, tail2) {
      this.head = head5;
      this.tail = tail2;
    };
    function finalCell(head5) {
      return new ConsCell(head5, emptyList);
    }
    function consList(x) {
      return function(xs) {
        return new ConsCell(x, xs);
      };
    }
    function listToArray(list) {
      var arr = [];
      var xs = list;
      while (xs !== emptyList) {
        arr.push(xs.head);
        xs = xs.tail;
      }
      return arr;
    }
    return function(apply5) {
      return function(map18) {
        return function(f) {
          var buildFrom = function(x, ys) {
            return apply5(map18(consList)(f(x)))(ys);
          };
          var go2 = function(acc, currentLen, xs) {
            if (currentLen === 0) {
              return acc;
            } else {
              var last2 = xs[currentLen - 1];
              return new Cont(function() {
                var built = go2(buildFrom(last2, acc), currentLen - 1, xs);
                return built;
              });
            }
          };
          return function(array) {
            var acc = map18(finalCell)(f(array[array.length - 1]));
            var result = go2(acc, array.length - 1, array);
            while (result instanceof Cont) {
              result = result.fn();
            }
            return map18(listToArray)(result);
          };
        };
      };
    };
  }();

  // output/Foreign.Object/foreign.js
  function _copyST(m) {
    return function() {
      var r = {};
      for (var k in m) {
        if (hasOwnProperty.call(m, k)) {
          r[k] = m[k];
        }
      }
      return r;
    };
  }
  var empty4 = {};
  function runST(f) {
    return f();
  }
  function _foldM(bind5) {
    return function(f) {
      return function(mz) {
        return function(m) {
          var acc = mz;
          function g2(k2) {
            return function(z) {
              return f(z)(k2)(m[k2]);
            };
          }
          for (var k in m) {
            if (hasOwnProperty.call(m, k)) {
              acc = bind5(acc)(g2(k));
            }
          }
          return acc;
        };
      };
    };
  }
  function toArrayWithKey(f) {
    return function(m) {
      var r = [];
      for (var k in m) {
        if (hasOwnProperty.call(m, k)) {
          r.push(f(k)(m[k]));
        }
      }
      return r;
    };
  }
  var keys2 = Object.keys || toArrayWithKey(function(k) {
    return function() {
      return k;
    };
  });

  // output/Foreign.Object.ST/foreign.js
  function poke2(k) {
    return function(v) {
      return function(m) {
        return function() {
          m[k] = v;
          return m;
        };
      };
    };
  }
  var deleteImpl = function(k) {
    return function(m) {
      return function() {
        delete m[k];
        return m;
      };
    };
  };

  // output/Foreign.Object/index.js
  var foldr3 = /* @__PURE__ */ foldr(foldableArray);
  var values = /* @__PURE__ */ toArrayWithKey(function(v) {
    return function(v1) {
      return v1;
    };
  });
  var thawST = _copyST;
  var mutate = function(f) {
    return function(m) {
      return runST(function __do2() {
        var s2 = thawST(m)();
        f(s2)();
        return s2;
      });
    };
  };
  var insert4 = function(k) {
    return function(v) {
      return mutate(poke2(k)(v));
    };
  };
  var fold3 = /* @__PURE__ */ _foldM(applyFlipped);
  var foldMap3 = function(dictMonoid) {
    var append13 = append(dictMonoid.Semigroup0());
    var mempty5 = mempty(dictMonoid);
    return function(f) {
      return fold3(function(acc) {
        return function(k) {
          return function(v) {
            return append13(acc)(f(k)(v));
          };
        };
      })(mempty5);
    };
  };
  var foldableObject = {
    foldl: function(f) {
      return fold3(function(z) {
        return function(v) {
          return f(z);
        };
      });
    },
    foldr: function(f) {
      return function(z) {
        return function(m) {
          return foldr3(f)(z)(values(m));
        };
      };
    },
    foldMap: function(dictMonoid) {
      var foldMap12 = foldMap3(dictMonoid);
      return function(f) {
        return foldMap12($$const(f));
      };
    }
  };
  var $$delete5 = function(k) {
    return mutate(deleteImpl(k));
  };

  // output/Bolson.Control/index.js
  var keepLatest3 = /* @__PURE__ */ keepLatest(eventIsEvent);
  var map5 = /* @__PURE__ */ map(functorEvent);
  var merge2 = /* @__PURE__ */ merge(foldableArray);
  var bind2 = /* @__PURE__ */ bind(bindST);
  var pure1 = /* @__PURE__ */ pure(applicativeST);
  var map12 = /* @__PURE__ */ map(functorST);
  var for_3 = /* @__PURE__ */ for_(applicativeST);
  var for_12 = /* @__PURE__ */ for_3(foldableMaybe);
  var $$void4 = /* @__PURE__ */ $$void(functorST);
  var for_23 = /* @__PURE__ */ for_3(foldableArray);
  var map32 = /* @__PURE__ */ map(functorArray);
  var append3 = /* @__PURE__ */ append(/* @__PURE__ */ semigroupST(semigroupString));
  var traverse_2 = /* @__PURE__ */ traverse_(applicativeST)(foldableArray);
  var append12 = /* @__PURE__ */ append(semigroupArray);
  var foldl3 = /* @__PURE__ */ foldl(foldableObject);
  var applySecond2 = /* @__PURE__ */ applySecond(applyST);
  var Begin = /* @__PURE__ */ function() {
    function Begin3() {
    }
    ;
    Begin3.value = new Begin3();
    return Begin3;
  }();
  var Middle = /* @__PURE__ */ function() {
    function Middle2() {
    }
    ;
    Middle2.value = new Middle2();
    return Middle2;
  }();
  var End = /* @__PURE__ */ function() {
    function End3() {
    }
    ;
    End3.value = new End3();
    return End3;
  }();
  var flatten = function(v) {
    return function(psr) {
      return function(interpreter) {
        var element = function(v1) {
          return v1(psr)(interpreter);
        };
        return function(v1) {
          if (v1 instanceof FixedChildren$prime) {
            return merge2(map32(flatten(v)(psr)(interpreter))(v1.value0));
          }
          ;
          if (v1 instanceof EventfulElement$prime) {
            return keepLatest3(map5(flatten(v)(psr)(interpreter))(v1.value0));
          }
          ;
          if (v1 instanceof Element$prime) {
            return element(v.toElt(v1.value0));
          }
          ;
          if (v1 instanceof DynamicChildren$prime) {
            return makeLemmingEventO(function(v2, v3) {
              var cancelInner = newSTRef(empty4)();
              var cancelOuter = v2(v1.value0, function(inner) {
                var myUnsubId = v.ids(interpreter)();
                var myUnsub = newSTRef(pure1(unit))();
                var eltsUnsubId = v.ids(interpreter)();
                var eltsUnsub = newSTRef(pure1(unit))();
                var myIds = newSTRef([])();
                var myImmediateCancellation = newSTRef(pure1(unit))();
                var myScope = map12(Local.create)(function() {
                  if (psr.scope instanceof Global) {
                    return v.ids(interpreter);
                  }
                  ;
                  if (psr.scope instanceof Local) {
                    return append3(pure1(psr.scope.value0))(append3(pure1("!"))(v.ids(interpreter)));
                  }
                  ;
                  throw new Error("Failed pattern match at Bolson.Control (line 547, column 17 - line 549, column 67): " + [psr.scope.constructor.name]);
                }())();
                var stageRef = newSTRef(Begin.value)();
                var c0 = v2(inner, function(kid$prime) {
                  var stage = read(stageRef)();
                  if (kid$prime instanceof Logic && stage instanceof Middle) {
                    var curId = read(myIds)();
                    return traverse_2(function(i2) {
                      return function() {
                        return v3(v.doLogic(kid$prime.value0)(interpreter)(i2));
                      };
                    })(curId)();
                  }
                  ;
                  if (kid$prime instanceof Remove && stage instanceof Middle) {
                    $$void4(write(End.value)(stageRef))();
                    var mic = function __do2() {
                      var idRef = read(myIds)();
                      for_23(idRef)(function(old) {
                        return for_12(psr.parent)(function(pnt) {
                          return function() {
                            return v3(v.disconnectElement(interpreter)({
                              id: old,
                              parent: pnt,
                              scope: myScope
                            }));
                          };
                        });
                      })();
                      var myu = read(myUnsub)();
                      myu();
                      var eltu = read(eltsUnsub)();
                      eltu();
                      $$void4(modify2($$delete5(myUnsubId))(cancelInner))();
                      return $$void4(modify2($$delete5(eltsUnsubId))(cancelInner))();
                    };
                    $$void4(write(mic)(myImmediateCancellation))();
                    return mic();
                  }
                  ;
                  if (kid$prime instanceof Insert && stage instanceof Begin) {
                    $$void4(write(Middle.value)(stageRef))();
                    var c1 = v2(flatten(v)(function() {
                      var $132 = {};
                      for (var $133 in psr) {
                        if ({}.hasOwnProperty.call(psr, $133)) {
                          $132[$133] = psr[$133];
                        }
                        ;
                      }
                      ;
                      $132.scope = myScope;
                      $132.raiseId = function(id) {
                        return $$void4(modify2(append12([id]))(myIds));
                      };
                      return $132;
                    }())(interpreter)(kid$prime.value0), v3);
                    $$void4(modify2(insert4(eltsUnsubId)(c1))(cancelInner))();
                    return $$void4(write(c1)(eltsUnsub))();
                  }
                  ;
                  return unit;
                });
                $$void4(write(c0)(myUnsub))();
                $$void4(modify2(insert4(myUnsubId)(c0))(cancelInner))();
                var mican = read(myImmediateCancellation)();
                return mican();
              });
              return function __do2() {
                bind2(read(cancelInner))(foldl3(applySecond2)(pure1(unit)))();
                return cancelOuter();
              };
            });
          }
          ;
          throw new Error("Failed pattern match at Bolson.Control (line 520, column 17 - line 610, column 20): " + [v1.constructor.name]);
        };
      };
    };
  };

  // output/Data.Profunctor/index.js
  var identity5 = /* @__PURE__ */ identity(categoryFn);
  var profunctorFn = {
    dimap: function(a2b) {
      return function(c2d) {
        return function(b2c) {
          return function($18) {
            return c2d(b2c(a2b($18)));
          };
        };
      };
    }
  };
  var dimap = function(dict) {
    return dict.dimap;
  };
  var lcmap = function(dictProfunctor) {
    var dimap1 = dimap(dictProfunctor);
    return function(a2b) {
      return dimap1(a2b)(identity5);
    };
  };

  // output/Deku.Attribute/index.js
  var pure5 = /* @__PURE__ */ pure(applicativeEvent);
  var Cb = function(x) {
    return x;
  };
  var Prop$prime = /* @__PURE__ */ function() {
    function Prop$prime2(value0) {
      this.value0 = value0;
    }
    ;
    Prop$prime2.create = function(value0) {
      return new Prop$prime2(value0);
    };
    return Prop$prime2;
  }();
  var Cb$prime = /* @__PURE__ */ function() {
    function Cb$prime2(value0) {
      this.value0 = value0;
    }
    ;
    Cb$prime2.create = function(value0) {
      return new Cb$prime2(value0);
    };
    return Cb$prime2;
  }();
  var Unset$prime = /* @__PURE__ */ function() {
    function Unset$prime2() {
    }
    ;
    Unset$prime2.value = new Unset$prime2();
    return Unset$prime2;
  }();
  var Attribute = function(x) {
    return x;
  };
  var unsafeUnAttribute = /* @__PURE__ */ coerce();
  var unsafeAttribute = Attribute;
  var prop$prime = /* @__PURE__ */ function() {
    return Prop$prime.create;
  }();
  var cb$prime = /* @__PURE__ */ function() {
    return Cb$prime.create;
  }();
  var cb = /* @__PURE__ */ function() {
    var $27 = map(functorFn)(map(functorEffect)($$const(true)));
    return function($28) {
      return Cb($27($28));
    };
  }();
  var attr = function(dict) {
    return dict.attr;
  };
  var pureAttr = function(dictAttr) {
    var attr1 = attr(dictAttr);
    return function(a2) {
      return function(b2) {
        return pure5(attr1(a2)(b2));
      };
    };
  };

  // output/Deku.Core/index.js
  var map6 = /* @__PURE__ */ map(functorEvent);
  var lcmap2 = /* @__PURE__ */ lcmap(profunctorFn);
  var unwrap2 = /* @__PURE__ */ unwrap();
  var eq2 = /* @__PURE__ */ eq(eqScope);
  var coerce3 = /* @__PURE__ */ coerce();
  var pure6 = /* @__PURE__ */ pure(applicativeST);
  var pure12 = /* @__PURE__ */ pure(applicativeEvent);
  var empty5 = /* @__PURE__ */ empty(plusEvent);
  var merge3 = /* @__PURE__ */ merge(foldableArray);
  var unsafeSetPos$prime = function(i2) {
    return function(v) {
      var g2 = function(v1) {
        var f = function(ii) {
          if (ii instanceof Element$prime) {
            return new Element$prime(lcmap2(function(v2) {
              return {
                pos: i2,
                dynFamily: v2.dynFamily,
                ez: v2.ez,
                parent: v2.parent,
                raiseId: v2.raiseId,
                scope: v2.scope
              };
            })(ii.value0));
          }
          ;
          if (ii instanceof EventfulElement$prime) {
            return new EventfulElement$prime(map6(f)(ii.value0));
          }
          ;
          return ii;
        };
        return f(v1);
      };
      return g2(v);
    };
  };
  var unsafeSetPos = function($104) {
    return unsafeSetPos$prime(Just.create($104));
  };
  var remove = /* @__PURE__ */ function() {
    return Remove.value;
  }();
  var portalFlatten = function() {
    return {
      doLogic: function(pos) {
        return function(v) {
          return function(id) {
            return v.sendToPos({
              id,
              pos
            });
          };
        };
      },
      ids: function($105) {
        return function(v) {
          return v.ids;
        }(unwrap2($105));
      },
      disconnectElement: function(v) {
        return function(v1) {
          return v.disconnectElement({
            id: v1.id,
            scope: v1.scope,
            parent: v1.parent,
            scopeEq: eq2
          });
        };
      },
      toElt: function(v) {
        return v;
      }
    };
  };
  var portalFlatten1 = /* @__PURE__ */ portalFlatten();
  var insert_ = function(x) {
    var f = function(v) {
      return new Insert(v);
    };
    var b2 = unsafeSetPos$prime(Nothing.value)(x);
    return f(function(v) {
      return v;
    }(b2));
  };
  var bus2 = function(f) {
    return bus(f);
  };
  var bussed = function(f) {
    var z = function(x) {
      return new EventfulElement$prime(coerce3(x));
    };
    var g2 = bus2(f);
    return z(map6(function(v) {
      return v;
    })(g2));
  };
  var bussedUncurried = function($107) {
    return bussed(curry($107));
  };
  var __internalDekuFlatten = function(a2) {
    return function(b2) {
      return function(c) {
        return flatten(portalFlatten1)(a2)(b2)(function(v) {
          return v;
        }(c));
      };
    };
  };
  var dynify = function(f) {
    return function(es) {
      var go2 = function(fes) {
        return function(v) {
          return function(v1) {
            return makeLemmingEventO(function(v2, k) {
              var me = v1.ids();
              v.raiseId(me)();
              var v3 = function() {
                if (v.parent instanceof Nothing) {
                  var dummyParent = v1.ids();
                  return new Tuple(pure12(v1.makeElement({
                    id: dummyParent,
                    parent: Nothing.value,
                    scope: v.scope,
                    tag: "div",
                    pos: Nothing.value,
                    dynFamily: Nothing.value
                  })), dummyParent);
                }
                ;
                if (v.parent instanceof Just) {
                  return new Tuple(empty5, v.parent.value0);
                }
                ;
                throw new Error("Failed pattern match at Deku.Core (line 451, column 38 - line 467, column 40): " + [v.parent.constructor.name]);
              }();
              var unsub = v2(merge3([v3.value0, pure12(v1.makeDynBeacon({
                id: me,
                parent: new Just(v3.value1),
                scope: v.scope,
                dynFamily: v.dynFamily,
                pos: v.pos
              })), pure12(v1.attributeParent({
                id: me,
                parent: v3.value1,
                pos: v.pos,
                dynFamily: v.dynFamily,
                ez: v.ez
              })), __internalDekuFlatten({
                parent: new Just(v3.value1),
                scope: v.scope,
                ez: false,
                raiseId: function(v4) {
                  return pure6(unit);
                },
                pos: Nothing.value,
                dynFamily: new Just(me)
              })(v1)(fes)]), k);
              return function __do2() {
                k(v1.removeDynBeacon({
                  id: me
                }));
                return unsub();
              };
            });
          };
        };
      };
      var go$prime = function(x) {
        return new Element$prime(go2(x));
      };
      return go$prime(function(v) {
        return v;
      }(f(es)));
    };
  };
  var dyn2 = /* @__PURE__ */ function() {
    var myDyn$prime = function(x) {
      return dyn(x);
    };
    var myDyn = function(e) {
      return myDyn$prime(map6(map6(function(v) {
        return v;
      }))(e));
    };
    return dynify(myDyn);
  }();

  // output/Deku.Control/index.js
  var map7 = /* @__PURE__ */ map(functorEvent);
  var merge4 = /* @__PURE__ */ merge(foldableArray);
  var pure7 = /* @__PURE__ */ pure(applicativeEvent);
  var empty6 = /* @__PURE__ */ empty(plusEvent);
  var pure13 = /* @__PURE__ */ pure(applicativeST);
  var mapAccum2 = /* @__PURE__ */ mapAccum(eventIsEvent);
  var keepLatest4 = /* @__PURE__ */ keepLatest(eventIsEvent);
  var filter6 = /* @__PURE__ */ filter4(filterableEvent);
  var eq3 = /* @__PURE__ */ eq(eqInt);
  var coerce4 = /* @__PURE__ */ coerce();
  var unwrap3 = /* @__PURE__ */ unwrap();
  var eq12 = /* @__PURE__ */ eq(eqScope);
  var alt2 = /* @__PURE__ */ alt(altEvent);
  var append4 = /* @__PURE__ */ append(semigroupArray);
  var mapWithIndex3 = /* @__PURE__ */ mapWithIndex(functorWithIndexArray);
  var map13 = /* @__PURE__ */ map(functorFn);
  var unsafeSetText = function(v) {
    return function(id) {
      return function(txt) {
        return map7(function($146) {
          return v.setText(function(v1) {
            return {
              id,
              text: v1
            };
          }($146));
        })(txt);
      };
    };
  };
  var unsafeSetAttribute = function(v) {
    return function(id) {
      return function(atts) {
        return map7(function($147) {
          return function(v1) {
            if (v1.value instanceof Prop$prime) {
              return v.setProp({
                id,
                key: v1.key,
                value: v1.value.value0
              });
            }
            ;
            if (v1.value instanceof Cb$prime) {
              return v.setCb({
                id,
                key: v1.key,
                value: v1.value.value0
              });
            }
            ;
            if (v1.value instanceof Unset$prime) {
              return v.unsetAttribute({
                id,
                key: v1.key
              });
            }
            ;
            throw new Error("Failed pattern match at Deku.Control (line 72, column 28 - line 75, column 47): " + [v1.value.constructor.name]);
          }(unsafeUnAttribute($147));
        })(atts);
      };
    };
  };
  var text = function(txt) {
    var go2 = function(v) {
      return function(v1) {
        return makeLemmingEventO(function(v2, k) {
          var me = v1.ids();
          v.raiseId(me)();
          var unsub = v2(merge4([pure7(v1.makeText({
            id: me,
            parent: v.parent,
            pos: v.pos,
            scope: v.scope,
            dynFamily: v.dynFamily
          })), unsafeSetText(v1)(me)(txt), maybe(empty6)(function(p2) {
            return pure7(v1.attributeParent({
              id: me,
              parent: p2,
              pos: v.pos,
              dynFamily: v.dynFamily,
              ez: v.ez
            }));
          })(v.parent)]), k);
          return function __do2() {
            k(v1.deleteFromCache({
              id: me
            }));
            return unsub();
          };
        });
      };
    };
    var go$prime = new Element$prime(go2);
    return go$prime;
  };
  var text_ = function(txt) {
    return text(pure7(txt));
  };
  var switcher = function(f) {
    return function(event) {
      var counter = function() {
        var fn = function(a2) {
          return function(b2) {
            return new Tuple(a2 + 1 | 0, new Tuple(b2, a2));
          };
        };
        return mapAccum2(fn)(0);
      }();
      return dyn2(keepLatest4(memoize(counter(event))(function(cenv) {
        return map7(function(v) {
          return merge4([map7($$const(remove))(filter6(function() {
            var $148 = eq3(v.value1 + 1 | 0);
            return function($149) {
              return $148(snd($149));
            };
          }())(cenv)), pure7(insert_(coerce4(f(v.value0))))]);
        })(cenv);
      })));
    };
  };
  var portalFlatten2 = function() {
    return {
      doLogic: function(pos) {
        return function(v) {
          return function(id) {
            return v.sendToPos({
              id,
              pos
            });
          };
        };
      },
      ids: function($150) {
        return function(v) {
          return v.ids;
        }(unwrap3($150));
      },
      disconnectElement: function(v) {
        return function(v1) {
          return v.disconnectElement({
            id: v1.id,
            scope: v1.scope,
            parent: v1.parent,
            scopeEq: eq12
          });
        };
      },
      toElt: function(v) {
        return v;
      }
    };
  };
  var portalFlatten12 = /* @__PURE__ */ portalFlatten2();
  var __internalDekuFlatten2 = function(a2) {
    return function(b2) {
      return function(v) {
        return flatten(portalFlatten12)(a2)(b2)(v);
      };
    };
  };
  var deku = function(root) {
    return function(v) {
      var go2 = function(children) {
        return function(v1) {
          return makeLemmingEventO(function(v2, k) {
            return v2(alt2(pure7(v1.makeRoot({
              id: "deku-root",
              root
            })))(__internalDekuFlatten2({
              parent: new Just("deku-root"),
              scope: new Local("rootScope"),
              raiseId: function(v3) {
                return pure13(unit);
              },
              ez: true,
              pos: Nothing.value,
              dynFamily: Nothing.value
            })(v1)(children)), k);
          });
        };
      };
      return go2(v);
    };
  };
  var elementify = function(tag) {
    return function(atts) {
      return function(children) {
        var go2 = function(v) {
          return function(v1) {
            return makeLemmingEventO(function(v2, k) {
              var me = v1.ids();
              v.raiseId(me)();
              var unsub = v2(alt2(merge4(append4([pure7(v1.makeElement({
                id: me,
                parent: v.parent,
                scope: v.scope,
                tag,
                pos: v.pos,
                dynFamily: v.dynFamily
              })), unsafeSetAttribute(v1)(me)(atts)])(maybe([])(function(p2) {
                return [pure7(v1.attributeParent({
                  id: me,
                  parent: p2,
                  pos: v.pos,
                  dynFamily: v.dynFamily,
                  ez: v.ez
                }))];
              })(v.parent))))(__internalDekuFlatten2({
                parent: new Just(me),
                scope: v.scope,
                ez: true,
                raiseId: function(v3) {
                  return pure13(unit);
                },
                pos: Nothing.value,
                dynFamily: Nothing.value
              })(v1)(children)), k);
              return function __do2() {
                k(v1.deleteFromCache({
                  id: me
                }));
                return unsub();
              };
            });
          };
        };
        return go2;
      };
    };
  };
  var elementify2 = function(en) {
    return function(attributes) {
      return function(kids) {
        var aa = function(v) {
          if (v.length === 0) {
            return empty6;
          }
          ;
          if (v.length === 1) {
            return v[0];
          }
          ;
          return merge4(v);
        };
        var step1 = function(arr) {
          return new Element$prime(elementify(en)(aa(attributes))(fixed(coerce4(arr))));
        };
        return step1(mapWithIndex3(map13(map13(function(v) {
          return v;
        }))(unsafeSetPos))(kids));
      };
    };
  };

  // output/Deku.DOM.Elt.Div/index.js
  var div2 = /* @__PURE__ */ elementify2("div");
  var div_ = /* @__PURE__ */ div2(/* @__PURE__ */ empty(plusArray));

  // output/Deku.DOM.Elt.H1/index.js
  var h1 = /* @__PURE__ */ elementify2("h1");
  var h1_ = /* @__PURE__ */ h1(/* @__PURE__ */ empty(plusArray));

  // output/Deku.DOM.Elt.Li/index.js
  var li = /* @__PURE__ */ elementify2("li");
  var li_ = /* @__PURE__ */ li(/* @__PURE__ */ empty(plusArray));

  // output/Deku.DOM.Elt.Ul/index.js
  var ul = /* @__PURE__ */ elementify2("ul");
  var ul_ = /* @__PURE__ */ ul(/* @__PURE__ */ empty(plusArray));

  // output/Data.CatQueue/index.js
  var CatQueue = /* @__PURE__ */ function() {
    function CatQueue2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    CatQueue2.create = function(value0) {
      return function(value1) {
        return new CatQueue2(value0, value1);
      };
    };
    return CatQueue2;
  }();
  var uncons2 = function($copy_v) {
    var $tco_done = false;
    var $tco_result;
    function $tco_loop(v) {
      if (v.value0 instanceof Nil && v.value1 instanceof Nil) {
        $tco_done = true;
        return Nothing.value;
      }
      ;
      if (v.value0 instanceof Nil) {
        $copy_v = new CatQueue(reverse2(v.value1), Nil.value);
        return;
      }
      ;
      if (v.value0 instanceof Cons) {
        $tco_done = true;
        return new Just(new Tuple(v.value0.value0, new CatQueue(v.value0.value1, v.value1)));
      }
      ;
      throw new Error("Failed pattern match at Data.CatQueue (line 82, column 1 - line 82, column 63): " + [v.constructor.name]);
    }
    ;
    while (!$tco_done) {
      $tco_result = $tco_loop($copy_v);
    }
    ;
    return $tco_result;
  };
  var snoc2 = function(v) {
    return function(a2) {
      return new CatQueue(v.value0, new Cons(a2, v.value1));
    };
  };
  var $$null = function(v) {
    if (v.value0 instanceof Nil && v.value1 instanceof Nil) {
      return true;
    }
    ;
    return false;
  };
  var empty7 = /* @__PURE__ */ function() {
    return new CatQueue(Nil.value, Nil.value);
  }();

  // output/Data.CatList/index.js
  var CatNil = /* @__PURE__ */ function() {
    function CatNil2() {
    }
    ;
    CatNil2.value = new CatNil2();
    return CatNil2;
  }();
  var CatCons = /* @__PURE__ */ function() {
    function CatCons2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    CatCons2.create = function(value0) {
      return function(value1) {
        return new CatCons2(value0, value1);
      };
    };
    return CatCons2;
  }();
  var link = function(v) {
    return function(v1) {
      if (v instanceof CatNil) {
        return v1;
      }
      ;
      if (v1 instanceof CatNil) {
        return v;
      }
      ;
      if (v instanceof CatCons) {
        return new CatCons(v.value0, snoc2(v.value1)(v1));
      }
      ;
      throw new Error("Failed pattern match at Data.CatList (line 108, column 1 - line 108, column 54): " + [v.constructor.name, v1.constructor.name]);
    };
  };
  var foldr4 = function(k) {
    return function(b2) {
      return function(q2) {
        var foldl4 = function($copy_v) {
          return function($copy_v1) {
            return function($copy_v2) {
              var $tco_var_v = $copy_v;
              var $tco_var_v1 = $copy_v1;
              var $tco_done = false;
              var $tco_result;
              function $tco_loop(v, v1, v2) {
                if (v2 instanceof Nil) {
                  $tco_done = true;
                  return v1;
                }
                ;
                if (v2 instanceof Cons) {
                  $tco_var_v = v;
                  $tco_var_v1 = v(v1)(v2.value0);
                  $copy_v2 = v2.value1;
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.CatList (line 124, column 3 - line 124, column 59): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
              }
              ;
              while (!$tco_done) {
                $tco_result = $tco_loop($tco_var_v, $tco_var_v1, $copy_v2);
              }
              ;
              return $tco_result;
            };
          };
        };
        var go2 = function($copy_xs) {
          return function($copy_ys) {
            var $tco_var_xs = $copy_xs;
            var $tco_done1 = false;
            var $tco_result;
            function $tco_loop(xs, ys) {
              var v = uncons2(xs);
              if (v instanceof Nothing) {
                $tco_done1 = true;
                return foldl4(function(x) {
                  return function(i2) {
                    return i2(x);
                  };
                })(b2)(ys);
              }
              ;
              if (v instanceof Just) {
                $tco_var_xs = v.value0.value1;
                $copy_ys = new Cons(k(v.value0.value0), ys);
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.CatList (line 120, column 14 - line 122, column 67): " + [v.constructor.name]);
            }
            ;
            while (!$tco_done1) {
              $tco_result = $tco_loop($tco_var_xs, $copy_ys);
            }
            ;
            return $tco_result;
          };
        };
        return go2(q2)(Nil.value);
      };
    };
  };
  var uncons3 = function(v) {
    if (v instanceof CatNil) {
      return Nothing.value;
    }
    ;
    if (v instanceof CatCons) {
      return new Just(new Tuple(v.value0, function() {
        var $66 = $$null(v.value1);
        if ($66) {
          return CatNil.value;
        }
        ;
        return foldr4(link)(CatNil.value)(v.value1);
      }()));
    }
    ;
    throw new Error("Failed pattern match at Data.CatList (line 99, column 1 - line 99, column 61): " + [v.constructor.name]);
  };
  var empty8 = /* @__PURE__ */ function() {
    return CatNil.value;
  }();
  var append5 = link;
  var semigroupCatList = {
    append: append5
  };
  var snoc3 = function(cat) {
    return function(a2) {
      return append5(cat)(new CatCons(a2, empty7));
    };
  };

  // output/Control.Monad.Free/index.js
  var $runtime_lazy4 = function(name15, moduleName, init2) {
    var state4 = 0;
    var val;
    return function(lineNumber) {
      if (state4 === 2)
        return val;
      if (state4 === 1)
        throw new ReferenceError(name15 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
      state4 = 1;
      val = init2();
      state4 = 2;
      return val;
    };
  };
  var append6 = /* @__PURE__ */ append(semigroupCatList);
  var Free = /* @__PURE__ */ function() {
    function Free2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Free2.create = function(value0) {
      return function(value1) {
        return new Free2(value0, value1);
      };
    };
    return Free2;
  }();
  var Return = /* @__PURE__ */ function() {
    function Return2(value0) {
      this.value0 = value0;
    }
    ;
    Return2.create = function(value0) {
      return new Return2(value0);
    };
    return Return2;
  }();
  var Bind = /* @__PURE__ */ function() {
    function Bind2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    Bind2.create = function(value0) {
      return function(value1) {
        return new Bind2(value0, value1);
      };
    };
    return Bind2;
  }();
  var toView = function($copy_v) {
    var $tco_done = false;
    var $tco_result;
    function $tco_loop(v) {
      var runExpF = function(v22) {
        return v22;
      };
      var concatF = function(v22) {
        return function(r) {
          return new Free(v22.value0, append6(v22.value1)(r));
        };
      };
      if (v.value0 instanceof Return) {
        var v2 = uncons3(v.value1);
        if (v2 instanceof Nothing) {
          $tco_done = true;
          return new Return(v.value0.value0);
        }
        ;
        if (v2 instanceof Just) {
          $copy_v = concatF(runExpF(v2.value0.value0)(v.value0.value0))(v2.value0.value1);
          return;
        }
        ;
        throw new Error("Failed pattern match at Control.Monad.Free (line 227, column 7 - line 231, column 64): " + [v2.constructor.name]);
      }
      ;
      if (v.value0 instanceof Bind) {
        $tco_done = true;
        return new Bind(v.value0.value0, function(a2) {
          return concatF(v.value0.value1(a2))(v.value1);
        });
      }
      ;
      throw new Error("Failed pattern match at Control.Monad.Free (line 225, column 3 - line 233, column 56): " + [v.value0.constructor.name]);
    }
    ;
    while (!$tco_done) {
      $tco_result = $tco_loop($copy_v);
    }
    ;
    return $tco_result;
  };
  var resume$prime = function(k) {
    return function(j) {
      return function(f) {
        var v = toView(f);
        if (v instanceof Return) {
          return j(v.value0);
        }
        ;
        if (v instanceof Bind) {
          return k(v.value0)(v.value1);
        }
        ;
        throw new Error("Failed pattern match at Control.Monad.Free (line 213, column 17 - line 215, column 20): " + [v.constructor.name]);
      };
    };
  };
  var resume = function(dictFunctor) {
    var map18 = map(dictFunctor);
    return resume$prime(function(g2) {
      return function(i2) {
        return new Left(map18(i2)(g2));
      };
    })(Right.create);
  };
  var fromView = function(f) {
    return new Free(f, empty8);
  };
  var wrap2 = function(f) {
    return fromView(new Bind(f, unsafeCoerce2));
  };
  var freeMonad = {
    Applicative0: function() {
      return freeApplicative;
    },
    Bind1: function() {
      return freeBind;
    }
  };
  var freeFunctor = {
    map: function(k) {
      return function(f) {
        return bindFlipped(freeBind)(function() {
          var $189 = pure(freeApplicative);
          return function($190) {
            return $189(k($190));
          };
        }())(f);
      };
    }
  };
  var freeBind = {
    bind: function(v) {
      return function(k) {
        return new Free(v.value0, snoc3(v.value1)(k));
      };
    },
    Apply0: function() {
      return $lazy_freeApply(0);
    }
  };
  var freeApplicative = {
    pure: function($191) {
      return fromView(Return.create($191));
    },
    Apply0: function() {
      return $lazy_freeApply(0);
    }
  };
  var $lazy_freeApply = /* @__PURE__ */ $runtime_lazy4("freeApply", "Control.Monad.Free", function() {
    return {
      apply: ap(freeMonad),
      Functor0: function() {
        return freeFunctor;
      }
    };
  });
  var pure8 = /* @__PURE__ */ pure(freeApplicative);
  var liftF = function(f) {
    return fromView(new Bind(f, function($192) {
      return pure8($192);
    }));
  };

  // output/Deku.Interpret/foreign.js
  var attributeParent_ = (runOnJust2) => (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      const dom2 = state4.units[a2.parent].main;
      if (!(state4.units[a2.id].main && state4.units[a2.id].main.parentNode || state4.units[a2.id].startBeacon && state4.units[a2.id].startBeacon.parentNode)) {
        const iRan = a2.ez ? (() => {
          if (state4.units[a2.id].main) {
            dom2.appendChild(state4.units[a2.id].main);
          } else {
            dom2.appendChild(state4.units[a2.id].startBeacon);
            dom2.appendChild(state4.units[a2.id].endBeacon);
          }
          return true;
        })() : runOnJust2(a2.pos)((pos) => () => {
          return runOnJust2(a2.dynFamily)((dynFamily) => () => {
            var i2 = 0;
            var j = 0;
            var terminalDyn;
            while (j < dom2.childNodes.length) {
              if (dom2.childNodes[j].nodeType === 8 && dom2.childNodes[j].nodeValue === "%-%" + dynFamily) {
                j += 1;
                break;
              }
              j++;
            }
            const inserter = (k) => {
              const anchorNode = dom2.childNodes[k];
              if (state4.units[a2.id].startBeacon) {
                dom2.insertBefore(
                  state4.units[a2.id].startBeacon,
                  anchorNode
                );
                dom2.insertBefore(
                  state4.units[a2.id].endBeacon,
                  anchorNode
                );
              } else {
                dom2.insertBefore(state4.units[a2.id].main, anchorNode);
              }
            };
            while (j < dom2.childNodes.length) {
              var tmpDekuId;
              if (tmpDekuId = dom2.childNodes[j].$dekuId) {
                const insertHappened = runOnJust2(
                  state4.units[tmpDekuId].dynFamily
                )((tmpDynFamily) => () => {
                  const insertHappened2 = runOnJust2(
                    state4.units[tmpDekuId].pos
                  )((tmpPos) => () => {
                    if (dynFamily === tmpDynFamily && pos <= tmpPos) {
                      inserter(j);
                      return true;
                    }
                    return false;
                  })();
                  return insertHappened2;
                })();
                if (insertHappened) {
                  return true;
                }
              }
              if (i2 === pos) {
                inserter(j);
                return true;
              }
              if (dom2.childNodes[j].nodeType === 8 && dom2.childNodes[j].nodeValue === "%-%" + dynFamily + "%-%") {
                inserter(j);
                return true;
              }
              if (dom2.childNodes[j].nodeType === 8 && dom2.childNodes[j].nodeValue.substring(0, 3) === "%-%" && !terminalDyn) {
                terminalDyn = dom2.childNodes[j].nodeValue + "%-%";
              }
              if (!terminalDyn) {
                i2++;
              }
              if (dom2.childNodes[j].nodeType === 8 && dom2.childNodes[j].nodeValue === terminalDyn) {
                terminalDyn = void 0;
                i2++;
              }
              j++;
            }
            return false;
          })();
        })();
        if (!iRan) {
          if (a2.parent.indexOf("@!%") !== -1) {
            const usedDynBeacon = runOnJust2(a2.dynFamily)((df) => () => {
              if (state4.units[a2.id].main) {
                state4.units[df].endBeacon.parentNode.insertBefore(
                  state4.units[a2.id].main,
                  state4.units[df].endBeacon
                );
              } else {
                state4.units[df].endBeacon.parentNode.insertBefore(
                  state4.units[a2.id].endBeacon,
                  state4.units[df].endBeacon
                );
                state4.units[df].endBeacon.parentNode.insertBefore(
                  state4.units[a2.id].startBeacon,
                  state4.units[a2.id].endBeacon
                );
              }
              return true;
            })();
            if (usedDynBeacon) {
            } else if (state4.units[a2.id].main) {
              dom2.parentNode.replaceChild(state4.units[a2.id].main, dom2);
            } else {
              dom2.parentNode.replaceChild(state4.units[a2.id].endBeacon, dom2);
              state4.units[a2.id].endBeacon.parentNode.insertBefore(
                state4.units[a2.id].startBeacon,
                state4.units[a2.id].endBeacon
              );
            }
          } else {
            const hasADynFamily = runOnJust2(a2.dynFamily)((dynFamily) => () => {
              if (state4.units[a2.id].startBeacon) {
                dom2.insertBefore(
                  state4.units[a2.id].startBeacon,
                  state4.units[dynFamily].endBeacon
                );
                dom2.insertBefore(
                  state4.units[a2.id].endBeacon,
                  state4.units[dynFamily].endBeacon
                );
              } else {
                dom2.insertBefore(
                  state4.units[a2.id].main,
                  state4.units[dynFamily].endBeacon
                );
              }
              return true;
            })();
            if (!hasADynFamily) {
              if (state4.units[a2.id].startBeacon) {
                dom2.appendChild(state4.units[a2.id].startBeacon);
                dom2.appendChild(state4.units[a2.id].endBeacon);
              } else {
                dom2.appendChild(state4.units[a2.id].main);
              }
            }
          }
        }
      }
    }
  };
  var makeDynBeacon_ = (runOnJust2) => (tryHydration) => (a2) => (state4) => () => {
    var startBeacon;
    var endBeacon;
    var ptr = a2.id;
    if (!state4.scopes[a2.scope]) {
      state4.scopes[a2.scope] = [];
    }
    state4.scopes[a2.scope].push(ptr);
    const iRan = runOnJust2(a2.parent)(() => () => {
      if (state4.hydrating && tryHydration && (startBeacon = state4.allBeacons[a2.id]) && (endBeacon = state4.allBeacons[`${a2.id}%-%`])) {
        state4.units[ptr] = {
          listeners: {},
          parent: a2.parent,
          scope: a2.scope,
          pos: a2.pos,
          dynFamily: a2.dynFamily,
          startBeacon,
          endBeacon
        };
        startBeacon.$dekuId = ptr;
        endBeacon.$dekuId = ptr;
        return true;
      }
      return false;
    })();
    if (!iRan) {
      const startBeacon2 = document.createComment(`%-%${a2.id}`);
      const endBeacon2 = document.createComment(`%-%${a2.id}%-%`);
      state4.units[ptr] = {
        listeners: {},
        parent: a2.parent,
        dynFamily: a2.dynFamily,
        scope: a2.scope,
        pos: a2.pos,
        startBeacon: startBeacon2,
        endBeacon: endBeacon2
      };
      startBeacon2.$dekuId = ptr;
      endBeacon2.$dekuId = ptr;
    }
  };
  var svgTags = /* @__PURE__ */ new Set([
    "animate",
    "animateMotion",
    "animateTransform",
    "circle",
    "clipPath",
    "defs",
    "desc",
    "discard",
    "ellipse",
    "feBlend",
    "feColorMatrix",
    "feComponentTransfer",
    "feComposite",
    "feConvolveMatrix",
    "feDiffuseLighting",
    "feDisplacementMap",
    "feDistantLight",
    "feDropShadow",
    "feFlood",
    "feFuncA",
    "feFuncB",
    "feFuncG",
    "feFuncR",
    "feGaussianBlur",
    "feImage",
    "feMerge",
    "feMergeNode",
    "feMorphology",
    "feOffset",
    "fePointLight",
    "feSpecularLighting",
    "feSpotLight",
    "feTile",
    "feTurbulence",
    "filter",
    "foreignObject",
    "g",
    "image",
    "line",
    "linearGradient",
    "marker",
    "mask",
    "metadata",
    "mpath",
    "path",
    "pattern",
    "polygon",
    "polyline",
    "radialGradient",
    "rect",
    "set",
    "stop",
    "svg",
    "switch",
    "symbol",
    "text",
    "textPath",
    "title",
    "tspan",
    "use",
    "view"
  ]);
  var getDynFamily = (id) => (state4) => () => state4.units[id] && state4.units[id].dynFamily ? state4.units[id].dynFamily : (() => {
    throw new Error(`No positional information for ${id}`);
  })();
  var getParent = (id) => (state4) => () => state4.units[id] && state4.units[id].main && state4.units[id].main.parentNode && state4.units[id].main.parentNode.$dekuId ? state4.units[id].main.parentNode.$dekuId : state4.units[id] && state4.units[id].startBeacon && state4.units[id].startBeacon.parentNode && state4.units[id].startBeacon.parentNode.$dekuId ? state4.units[id].startBeacon.parentNode.$dekuId : (() => {
    throw new Error(`No parent information for ${id}`);
  })();
  var getScope = (id) => (state4) => () => state4.units[id] && state4.units[id].scope ? state4.units[id].scope : (() => {
    throw new Error(`No scope information for ${id}`);
  })();
  var makeElement_ = (runOnJust2) => (tryHydration) => (a2) => (state4) => () => {
    var dom2;
    var ptr = a2.id;
    if (!state4.scopes[a2.scope]) {
      state4.scopes[a2.scope] = [];
    }
    state4.scopes[a2.scope].push(ptr);
    const iRan = runOnJust2(a2.parent)(() => () => {
      if (state4.hydrating && tryHydration && (dom2 = document.documentElement.querySelector(
        `[data-deku-ssr="${ptr}"]`
      ))) {
        state4.units[ptr] = {
          listeners: {},
          pos: a2.pos,
          parent: a2.parent,
          scope: a2.scope,
          dynFamily: a2.dynFamily,
          main: dom2
        };
        dom2.$dekuId = ptr;
        return true;
      }
      return false;
    })();
    if (!iRan) {
      const main3 = svgTags.has(a2.tag) ? document.createElementNS("http://www.w3.org/2000/svg", a2.tag) : document.createElement(a2.tag);
      state4.units[ptr] = {
        listeners: {},
        parent: a2.parent,
        pos: a2.pos,
        scope: a2.scope,
        dynFamily: a2.dynFamily,
        main: main3
      };
      main3.$dekuId = ptr;
    }
  };
  var makeText_ = (runOnJust2) => (tryHydration) => (maybe2) => (a2) => (state4) => () => {
    var ptr = a2.id;
    var dom2;
    if (!state4.scopes[a2.scope]) {
      state4.scopes[a2.scope] = [];
    }
    state4.scopes[a2.scope].push(ptr);
    const iRan = runOnJust2(a2.parent)((parent2) => () => {
      if (state4.hydrating && tryHydration && // hack
      (dom2 = document.documentElement.querySelector(`[data-deku-ssr="${parent2}"]`))) {
        var i2 = 0;
        for (; i2 < dom2.childNodes.length; i2++) {
          const ptrSplit = ptr.split("@-@");
          if (dom2.childNodes[i2].nodeType === 8 && dom2.childNodes[i2].nodeValue === ptrSplit[0]) {
            var textWasBlank = i2 === 0 || dom2.childNodes[i2 - 1].nodeType !== 3;
            if (textWasBlank && i2 !== 0) {
              dom2.insertBefore(
                document.createTextNode(""),
                dom2.childNodes[i2]
              );
            } else if (textWasBlank) {
              dom2.prepend(document.createTextNode(""));
            } else {
              i2 = i2 - 1;
            }
            break;
          }
        }
        const main3 = dom2.childNodes[i2];
        state4.units[ptr] = {
          // if we've done ssr for a text node, it will be a span,
          // so we want to get the child node
          main: main3,
          pos: a2.pos,
          parent: a2.parent,
          scope: a2.scope
        };
        main3.$dekuId = ptr;
        return true;
      }
      return false;
    })();
    if (!iRan) {
      const main3 = document.createTextNode("");
      state4.units[ptr] = {
        main: main3,
        parent: a2.parent,
        scope: a2.scope,
        pos: a2.pos,
        dynFamily: a2.dynFamily
      };
      main3.$dekuId = ptr;
    }
  };
  function makeFFIDOMSnapshot() {
    return {
      units: {},
      scopes: {},
      allBeacons: {}
    };
  }
  var setProp_ = (tryHydration) => (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      var ptr = a2.id;
      var avv = a2.value;
      if (state4.hydrating && tryHydration && !state4.units[ptr] && (dom = document.documentElement.querySelector(`[data-deku-ssr="${ptr}"]`))) {
        state4.units[ptr] = {
          listeners: {},
          parent: a2.parent,
          scope: a2.scope,
          main: dom
        };
        if (!state4.scopes[a2.scope]) {
          state4.scopes[a2.scope] = [];
        }
        state4.scopes[a2.scope].push(ptr);
      }
      if (state4.units[ptr].main.tagName === "INPUT" && a2.key === "value") {
        state4.units[ptr].main.value = avv;
      } else if (state4.units[ptr].main.tagName === "TEXTAREA" && a2.key === "value") {
        state4.units[ptr].main.value = avv;
      } else if (state4.units[ptr].main.tagName === "INPUT" && a2.key === "checked") {
        state4.units[ptr].main.checked = avv === "true";
      } else if (a2.key === "disabled") {
        state4.units[ptr].main.disabled = avv === "true";
      } else {
        state4.units[ptr].main.setAttribute(a2.key, avv);
      }
    }
  };
  var setCb_ = (tryHydration) => (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      var ptr = a2.id;
      var avv = a2.value;
      if (state4.hydrating && tryHydration && !state4.units[ptr] && (dom = document.documentElement.querySelector(`[data-deku-ssr="${ptr}"]`))) {
        state4.units[ptr] = {
          listeners: {},
          parent: a2.parent,
          scope: a2.scope,
          main: dom
        };
        if (!state4.scopes[a2.scope]) {
          state4.scopes[a2.scope] = [];
        }
        state4.scopes[a2.scope].push(ptr);
      }
      if (a2.key === "@self@") {
        avv(state4.units[ptr].main)();
      } else {
        if (state4.units[ptr].listeners[a2.key]) {
          state4.units[ptr].main.removeEventListener(
            a2.key,
            state4.units[ptr].listeners[a2.key]
          );
        }
        var el = (e) => avv(e)();
        state4.units[ptr].main.addEventListener(a2.key, el);
        state4.units[ptr].listeners[a2.key] = el;
      }
    }
  };
  var unsetAttribute_ = (tryHydration) => (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      var ptr = a2.id;
      if (state4.hydrating && tryHydration && !state4.units[ptr] && (dom = document.documentElement.querySelector(`[data-deku-ssr="${ptr}"]`))) {
        state4.units[ptr] = {
          listeners: {},
          parent: a2.parent,
          scope: a2.scope,
          main: dom
        };
        if (!state4.scopes[a2.scope]) {
          state4.scopes[a2.scope] = [];
        }
        state4.scopes[a2.scope].push(ptr);
      }
      state4.units[ptr].main.removeAttribute(a2.key);
    }
  };
  var setText_ = (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      var ptr = a2.id;
      state4.units[ptr].main.nodeValue = a2.text;
    }
  };
  var makePursx_ = (runOnJust2) => (tryHydration) => (maybe2) => (a2) => (state4) => () => {
    var dom2;
    var tmp;
    var ptr = a2.id;
    var html2 = a2.html;
    var verb = a2.verb;
    var cache = a2.cache;
    var parent2 = a2.parent;
    var scope2 = a2.scope;
    var pxScope = a2.pxScope;
    const iRan = runOnJust2(a2.parent)(() => () => {
      if (state4.hydrating && tryHydration && // hack
      (dom2 = document.documentElement.querySelector(
        `[data-deku-ssr="${ptr}"]`
      ))) {
        state4.units[ptr] = {
          listeners: {},
          pos: a2.pos,
          scope: scope2,
          parent: parent2,
          main: dom2
        };
        dom2.$dekuId = ptr;
        return true;
      }
      return false;
    })();
    if (!iRan) {
      const entries = Object.entries(cache);
      for (var i2 = 0; i2 < entries.length; i2++) {
        const key2 = entries[i2][0];
        if (entries[i2][1] === true) {
          html2 = html2.replace(
            verb + key2 + verb,
            'data-deku-attr-internal="' + key2 + '"'
          );
        } else {
          html2 = html2.replace(
            verb + key2 + verb,
            '<span style="display:contents;" data-deku-elt-internal="' + key2 + '"></span>'
          );
        }
      }
      tmp = document.createElement("div");
      tmp.innerHTML = html2.trim();
      state4.units[ptr] = {
        listeners: {},
        pos: a2.pos,
        scope: scope2,
        parent: parent2,
        main: tmp.firstChild
      };
      tmp.firstChild.$dekuId = ptr;
    }
    if (!state4.scopes[scope2]) {
      state4.scopes[scope2] = [];
    }
    state4.scopes[scope2].push(ptr);
    if (!tmp) {
      tmp = dom2;
    }
    tmp.querySelectorAll("[data-deku-attr-internal]").forEach(function(e) {
      var key2 = e.getAttribute("data-deku-attr-internal");
      const namespacedKey = key2 + "@!%" + pxScope;
      state4.units[namespacedKey] = {
        listeners: {},
        main: e,
        scope: scope2
      };
      state4.scopes[scope2].push(namespacedKey);
    });
    tmp.querySelectorAll("[data-deku-elt-internal]").forEach(function(e) {
      var key2 = e.getAttribute("data-deku-elt-internal");
      const namespacedKey = key2 + "@!%" + pxScope;
      state4.units[key2 + "@!%" + pxScope] = {
        listeners: {},
        main: e,
        scope: scope2
      };
      state4.scopes[scope2].push(namespacedKey);
    });
    if (!iRan) {
      state4.units[ptr].main.remove();
    }
  };
  var makeRoot_ = (a2) => (state4) => () => {
    var ptr = a2.id;
    state4.units[ptr] = {
      main: a2.root
    };
    a2.root.$dekuId = ptr;
  };
  var giveNewParent_ = (just) => (runOnJust2) => (b2) => (state4) => () => {
    const insertAt2 = (ptr, parent2, node) => {
      if (state4.units[ptr].startBeacon) {
        var x2 = state4.units[ptr].startBeacon;
        var y2 = x2.nextSibling;
        state4.units[parent2].main.insertBefore(x2, node);
        x2 = y2;
        while (x2 && x2 !== state4.units[ptr].endBeacon) {
          y2 = x2.nextSibling;
          state4.units[parent2].main.insertBefore(x2, node);
          x2 = y2;
        }
      } else {
        state4.units[parent2].main.insertBefore(state4.units[ptr].main, node);
      }
    };
    const runMe = [];
    runMe.push(b2);
    for (var z = 0; z < runMe.length; z++) {
      const a2 = runMe[z];
      const ptr = a2.id;
      const parent2 = a2.parent;
      state4.units[ptr].containingScope = a2.scope;
      var aPos = void 0;
      runOnJust2(a2.pos)((myPos) => () => {
        aPos = myPos;
        return true;
      })();
      if (aPos === void 0) {
        aPos = Number.MAX_VALUE;
      }
      const nodes = state4.units[parent2].main.childNodes;
      var i2 = 0;
      var didInsert = false;
      var pos = 0;
      while (i2 < nodes.length) {
        var dkid;
        if (dkid = nodes[i2].$dekuId) {
          const insertedBeforeEndBeacon = runOnJust2(a2.dynFamily)((df) => () => {
            if (didInsert) {
              return false;
            }
            if (state4.units[dkid].endBeacon === nodes[i2] && df === dkid) {
              state4.units[ptr].pos = just(pos);
              insertAt2(ptr, parent2, nodes[i2]);
              return true;
            }
            return false;
          })();
          if (insertedBeforeEndBeacon) {
            didInsert = true;
            break;
          }
          if (state4.units[dkid].dynFamily !== state4.units[ptr].dynFamily) {
            i2++;
            continue;
          }
          if (didInsert) {
            i2++;
            continue;
          }
          if (pos === aPos) {
            insertAt2(ptr, parent2, nodes[i2]);
            pos++;
            didInsert = true;
          } else if (state4.units[dkid].endBeacon !== nodes[i2]) {
            state4.units[dkid].pos = just(pos);
            pos++;
          }
        }
        i2++;
      }
      if (didInsert) {
        return;
      }
      if (state4.units[ptr].main) {
        state4.units[parent2].main.appendChild(state4.units[ptr].main);
      } else {
        var x = state4.units[ptr].startBeacon;
        var y = x.nextSibling;
        state4.units[parent2].main.appendChild(x);
        x = y;
        while (x && x !== state4.units[ptr].endBeacon) {
          y = x.nextSibling;
          state4.units[parent2].main.appendChild(x);
          x = y;
        }
      }
    }
  };
  var disconnectElement_ = (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      var ptr = a2.id;
      if (state4.units[ptr].containingScope && !a2.scopeEq(state4.units[ptr].containingScope)(a2.scope)) {
        return;
      }
      if (state4.units[ptr].main) {
        state4.units[ptr].main.remove();
      } else {
        const dummy = document.createElement("div");
        var x = state4.units[ptr].startBeacon;
        var y = x.nextSibling;
        dummy.appendChild(x);
        x = y;
        while (x && x !== state4.units[ptr].endBeacon) {
          y = x.nextSibling;
          dummy.appendChild(x);
          x = y;
        }
        if (x === state4.units[ptr].endBeacon) {
          dummy.appendChild(x);
        }
      }
    }
  };
  var stateHasKey = (id) => (state4) => () => {
    return state4.units[id] !== void 0;
  };
  var deleteFromCache_ = (a2) => (state4) => () => {
    if (state4.units[a2.id]) {
      delete state4.units[a2.id];
    }
  };
  var removeDynBeacon_ = deleteFromCache_;

  // output/Data.String.Utils/foreign.js
  function includesImpl(searchString, str) {
    return str.includes(searchString);
  }

  // output/Data.String.CodePoints/foreign.js
  var hasArrayFrom = typeof Array.from === "function";
  var hasStringIterator = typeof Symbol !== "undefined" && Symbol != null && typeof Symbol.iterator !== "undefined" && typeof String.prototype[Symbol.iterator] === "function";
  var hasFromCodePoint = typeof String.prototype.fromCodePoint === "function";
  var hasCodePointAt = typeof String.prototype.codePointAt === "function";
  var _unsafeCodePointAt0 = function(fallback) {
    return hasCodePointAt ? function(str) {
      return str.codePointAt(0);
    } : fallback;
  };
  var _singleton = function(fallback) {
    return hasFromCodePoint ? String.fromCodePoint : fallback;
  };
  var _toCodePointArray = function(fallback) {
    return function(unsafeCodePointAt02) {
      if (hasArrayFrom) {
        return function(str) {
          return Array.from(str, unsafeCodePointAt02);
        };
      }
      return fallback;
    };
  };

  // output/Data.Enum/foreign.js
  function toCharCode(c) {
    return c.charCodeAt(0);
  }
  function fromCharCode(c) {
    return String.fromCharCode(c);
  }

  // output/Data.Enum/index.js
  var bottom1 = /* @__PURE__ */ bottom(boundedChar);
  var top1 = /* @__PURE__ */ top(boundedChar);
  var toEnum = function(dict) {
    return dict.toEnum;
  };
  var fromEnum = function(dict) {
    return dict.fromEnum;
  };
  var toEnumWithDefaults = function(dictBoundedEnum) {
    var toEnum1 = toEnum(dictBoundedEnum);
    var fromEnum1 = fromEnum(dictBoundedEnum);
    var bottom22 = bottom(dictBoundedEnum.Bounded0());
    return function(low2) {
      return function(high2) {
        return function(x) {
          var v = toEnum1(x);
          if (v instanceof Just) {
            return v.value0;
          }
          ;
          if (v instanceof Nothing) {
            var $140 = x < fromEnum1(bottom22);
            if ($140) {
              return low2;
            }
            ;
            return high2;
          }
          ;
          throw new Error("Failed pattern match at Data.Enum (line 158, column 33 - line 160, column 62): " + [v.constructor.name]);
        };
      };
    };
  };
  var defaultSucc = function(toEnum$prime) {
    return function(fromEnum$prime) {
      return function(a2) {
        return toEnum$prime(fromEnum$prime(a2) + 1 | 0);
      };
    };
  };
  var defaultPred = function(toEnum$prime) {
    return function(fromEnum$prime) {
      return function(a2) {
        return toEnum$prime(fromEnum$prime(a2) - 1 | 0);
      };
    };
  };
  var charToEnum = function(v) {
    if (v >= toCharCode(bottom1) && v <= toCharCode(top1)) {
      return new Just(fromCharCode(v));
    }
    ;
    return Nothing.value;
  };
  var enumChar = {
    succ: /* @__PURE__ */ defaultSucc(charToEnum)(toCharCode),
    pred: /* @__PURE__ */ defaultPred(charToEnum)(toCharCode),
    Ord0: function() {
      return ordChar;
    }
  };
  var boundedEnumChar = /* @__PURE__ */ function() {
    return {
      cardinality: toCharCode(top1) - toCharCode(bottom1) | 0,
      toEnum: charToEnum,
      fromEnum: toCharCode,
      Bounded0: function() {
        return boundedChar;
      },
      Enum1: function() {
        return enumChar;
      }
    };
  }();

  // output/Data.Int/foreign.js
  var fromNumberImpl = function(just) {
    return function(nothing) {
      return function(n) {
        return (n | 0) === n ? just(n) : nothing;
      };
    };
  };
  var toNumber = function(n) {
    return n;
  };

  // output/Data.Number/foreign.js
  var isFiniteImpl = isFinite;
  var floor = Math.floor;
  var remainder = function(n) {
    return function(m) {
      return n % m;
    };
  };

  // output/Data.Int/index.js
  var top2 = /* @__PURE__ */ top(boundedInt);
  var bottom2 = /* @__PURE__ */ bottom(boundedInt);
  var fromNumber = /* @__PURE__ */ function() {
    return fromNumberImpl(Just.create)(Nothing.value);
  }();
  var unsafeClamp = function(x) {
    if (!isFiniteImpl(x)) {
      return 0;
    }
    ;
    if (x >= toNumber(top2)) {
      return top2;
    }
    ;
    if (x <= toNumber(bottom2)) {
      return bottom2;
    }
    ;
    if (otherwise) {
      return fromMaybe(0)(fromNumber(x));
    }
    ;
    throw new Error("Failed pattern match at Data.Int (line 72, column 1 - line 72, column 29): " + [x.constructor.name]);
  };
  var floor2 = function($39) {
    return unsafeClamp(floor($39));
  };

  // output/Data.String.CodeUnits/foreign.js
  var fromCharArray = function(a2) {
    return a2.join("");
  };
  var toCharArray = function(s2) {
    return s2.split("");
  };
  var singleton7 = function(c) {
    return c;
  };
  var length5 = function(s2) {
    return s2.length;
  };
  var drop2 = function(n) {
    return function(s2) {
      return s2.substring(n);
    };
  };

  // output/Data.String.Unsafe/foreign.js
  var charAt = function(i2) {
    return function(s2) {
      if (i2 >= 0 && i2 < s2.length)
        return s2.charAt(i2);
      throw new Error("Data.String.Unsafe.charAt: Invalid index.");
    };
  };

  // output/Data.String.CodePoints/index.js
  var fromEnum2 = /* @__PURE__ */ fromEnum(boundedEnumChar);
  var map8 = /* @__PURE__ */ map(functorMaybe);
  var unfoldr2 = /* @__PURE__ */ unfoldr(unfoldableArray);
  var div3 = /* @__PURE__ */ div(euclideanRingInt);
  var mod2 = /* @__PURE__ */ mod(euclideanRingInt);
  var CodePoint = function(x) {
    return x;
  };
  var unsurrogate = function(lead) {
    return function(trail) {
      return (((lead - 55296 | 0) * 1024 | 0) + (trail - 56320 | 0) | 0) + 65536 | 0;
    };
  };
  var isTrail = function(cu) {
    return 56320 <= cu && cu <= 57343;
  };
  var isLead = function(cu) {
    return 55296 <= cu && cu <= 56319;
  };
  var uncons4 = function(s2) {
    var v = length5(s2);
    if (v === 0) {
      return Nothing.value;
    }
    ;
    if (v === 1) {
      return new Just({
        head: fromEnum2(charAt(0)(s2)),
        tail: ""
      });
    }
    ;
    var cu1 = fromEnum2(charAt(1)(s2));
    var cu0 = fromEnum2(charAt(0)(s2));
    var $43 = isLead(cu0) && isTrail(cu1);
    if ($43) {
      return new Just({
        head: unsurrogate(cu0)(cu1),
        tail: drop2(2)(s2)
      });
    }
    ;
    return new Just({
      head: cu0,
      tail: drop2(1)(s2)
    });
  };
  var unconsButWithTuple = function(s2) {
    return map8(function(v) {
      return new Tuple(v.head, v.tail);
    })(uncons4(s2));
  };
  var toCodePointArrayFallback = function(s2) {
    return unfoldr2(unconsButWithTuple)(s2);
  };
  var unsafeCodePointAt0Fallback = function(s2) {
    var cu0 = fromEnum2(charAt(0)(s2));
    var $47 = isLead(cu0) && length5(s2) > 1;
    if ($47) {
      var cu1 = fromEnum2(charAt(1)(s2));
      var $48 = isTrail(cu1);
      if ($48) {
        return unsurrogate(cu0)(cu1);
      }
      ;
      return cu0;
    }
    ;
    return cu0;
  };
  var unsafeCodePointAt0 = /* @__PURE__ */ _unsafeCodePointAt0(unsafeCodePointAt0Fallback);
  var toCodePointArray = /* @__PURE__ */ _toCodePointArray(toCodePointArrayFallback)(unsafeCodePointAt0);
  var length6 = function($74) {
    return length(toCodePointArray($74));
  };
  var fromCharCode2 = /* @__PURE__ */ function() {
    var $75 = toEnumWithDefaults(boundedEnumChar)(bottom(boundedChar))(top(boundedChar));
    return function($76) {
      return singleton7($75($76));
    };
  }();
  var singletonFallback = function(v) {
    if (v <= 65535) {
      return fromCharCode2(v);
    }
    ;
    var lead = div3(v - 65536 | 0)(1024) + 55296 | 0;
    var trail = mod2(v - 65536 | 0)(1024) + 56320 | 0;
    return fromCharCode2(lead) + fromCharCode2(trail);
  };
  var singleton8 = /* @__PURE__ */ _singleton(singletonFallback);
  var codePointFromChar = function($77) {
    return CodePoint(fromEnum2($77));
  };

  // output/Data.String.Utils/index.js
  var includes = function(searchString) {
    return function(s2) {
      return includesImpl(searchString, s2);
    };
  };

  // output/Random.LCG/index.js
  var mod3 = /* @__PURE__ */ mod(euclideanRingInt);
  var fromJust5 = /* @__PURE__ */ fromJust();
  var unSeed = function(v) {
    return v;
  };
  var seedMin = 1;
  var lcgM = 2147483647;
  var seedMax = /* @__PURE__ */ function() {
    return lcgM - 1 | 0;
  }();
  var mkSeed = function(x) {
    var ensureBetween = function(min5) {
      return function(max6) {
        return function(n) {
          var rangeSize = max6 - min5 | 0;
          var n$prime = mod3(n)(rangeSize);
          var $25 = n$prime < min5;
          if ($25) {
            return n$prime + max6 | 0;
          }
          ;
          return n$prime;
        };
      };
    };
    return ensureBetween(seedMin)(seedMax)(x);
  };
  var lcgC = 0;
  var lcgA = 48271;
  var lcgPerturb = function(d) {
    return function(v) {
      return fromJust5(fromNumber(remainder(toNumber(lcgA) * toNumber(v) + toNumber(d))(toNumber(lcgM))));
    };
  };
  var lcgNext = /* @__PURE__ */ lcgPerturb(lcgC);

  // output/Control.Monad.State.Class/index.js
  var state = function(dict) {
    return dict.state;
  };

  // output/Effect.Class/index.js
  var monadEffectEffect = {
    liftEffect: /* @__PURE__ */ identity(categoryFn),
    Monad0: function() {
      return monadEffect;
    }
  };
  var liftEffect = function(dict) {
    return dict.liftEffect;
  };

  // output/Control.Monad.State.Trans/index.js
  var functorStateT = function(dictFunctor) {
    var map18 = map(dictFunctor);
    return {
      map: function(f) {
        return function(v) {
          return function(s2) {
            return map18(function(v1) {
              return new Tuple(f(v1.value0), v1.value1);
            })(v(s2));
          };
        };
      }
    };
  };
  var monadStateT = function(dictMonad) {
    return {
      Applicative0: function() {
        return applicativeStateT(dictMonad);
      },
      Bind1: function() {
        return bindStateT(dictMonad);
      }
    };
  };
  var bindStateT = function(dictMonad) {
    var bind5 = bind(dictMonad.Bind1());
    return {
      bind: function(v) {
        return function(f) {
          return function(s2) {
            return bind5(v(s2))(function(v1) {
              var v3 = f(v1.value0);
              return v3(v1.value1);
            });
          };
        };
      },
      Apply0: function() {
        return applyStateT(dictMonad);
      }
    };
  };
  var applyStateT = function(dictMonad) {
    var functorStateT1 = functorStateT(dictMonad.Bind1().Apply0().Functor0());
    return {
      apply: ap(monadStateT(dictMonad)),
      Functor0: function() {
        return functorStateT1;
      }
    };
  };
  var applicativeStateT = function(dictMonad) {
    var pure11 = pure(dictMonad.Applicative0());
    return {
      pure: function(a2) {
        return function(s2) {
          return pure11(new Tuple(a2, s2));
        };
      },
      Apply0: function() {
        return applyStateT(dictMonad);
      }
    };
  };
  var monadStateStateT = function(dictMonad) {
    var pure11 = pure(dictMonad.Applicative0());
    var monadStateT1 = monadStateT(dictMonad);
    return {
      state: function(f) {
        return function($200) {
          return pure11(f($200));
        };
      },
      Monad0: function() {
        return monadStateT1;
      }
    };
  };

  // output/Control.Monad.State/index.js
  var evalState = function(v) {
    return function(s2) {
      var v1 = v(s2);
      return v1.value0;
    };
  };

  // output/Test.QuickCheck.Gen/index.js
  var monadStateStateT2 = /* @__PURE__ */ monadStateStateT(monadIdentity);
  var state2 = /* @__PURE__ */ state(monadStateStateT2);
  var functorStateT2 = /* @__PURE__ */ functorStateT(functorIdentity);
  var mul2 = /* @__PURE__ */ mul(semiringNumber);
  var add2 = /* @__PURE__ */ add(semiringNumber);
  var unGen = function(v) {
    return v;
  };
  var lcgStep = /* @__PURE__ */ function() {
    var f = function(s2) {
      return new Tuple(unSeed(s2.newSeed), function() {
        var $94 = {};
        for (var $95 in s2) {
          if ({}.hasOwnProperty.call(s2, $95)) {
            $94[$95] = s2[$95];
          }
          ;
        }
        ;
        $94.newSeed = lcgNext(s2.newSeed);
        return $94;
      }());
    };
    return state2(f);
  }();
  var functorGen = functorStateT2;
  var map22 = /* @__PURE__ */ map(functorGen);
  var evalGen = function($104) {
    return evalState(unGen($104));
  };
  var applyGen = /* @__PURE__ */ applyStateT(monadIdentity);
  var apply4 = /* @__PURE__ */ apply(applyGen);
  var chooseInt$prime = function(a2) {
    return function(b2) {
      var numB = toNumber(b2);
      var numA = toNumber(a2);
      var clamp = function(x) {
        return numA + remainder(x)(numB - numA + 1);
      };
      var choose31BitPosNumber = map22(toNumber)(lcgStep);
      var choose32BitPosNumber = apply4(map22(add2)(choose31BitPosNumber))(map22(mul2(2))(choose31BitPosNumber));
      return map22(function($109) {
        return floor2(clamp($109));
      })(choose32BitPosNumber);
    };
  };
  var chooseInt2 = function(a2) {
    return function(b2) {
      var $101 = a2 <= b2;
      if ($101) {
        return chooseInt$prime(a2)(b2);
      }
      ;
      return chooseInt$prime(b2)(a2);
    };
  };

  // output/Test.QuickCheck.Arbitrary/index.js
  var arbitrary = function(dict) {
    return dict.arbitrary;
  };
  var arbInt = /* @__PURE__ */ function() {
    return {
      arbitrary: chooseInt2(-1e6 | 0)(1e6)
    };
  }();

  // output/Deku.Interpret/index.js
  var map9 = /* @__PURE__ */ map(functorEvent);
  var map14 = /* @__PURE__ */ map(functorFn);
  var map23 = /* @__PURE__ */ map(functorEffect);
  var $$void5 = /* @__PURE__ */ $$void(functorST);
  var show2 = /* @__PURE__ */ show(showInt);
  var arbitrary2 = /* @__PURE__ */ arbitrary(arbInt);
  var add3 = /* @__PURE__ */ add(semiringInt);
  var pure14 = /* @__PURE__ */ pure(applicativeEffect);
  var mempty3 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidFn(/* @__PURE__ */ monoidST(monoidUnit)));
  var empty9 = /* @__PURE__ */ empty(plusEvent);
  var coerce5 = /* @__PURE__ */ coerce();
  var unwrap4 = /* @__PURE__ */ unwrap();
  var eq4 = /* @__PURE__ */ eq(eqScope);
  var join2 = /* @__PURE__ */ join(freeBind);
  var pure23 = /* @__PURE__ */ pure(applicativeEvent);
  var EFunctionOfFFIDOMSnapshot = function(x) {
    return x;
  };
  var functorEFunctionOfFFIDOMS = {
    map: function(f) {
      return function(m) {
        return map9(map14(map23(f)))(m);
      };
    }
  };
  var runOnJust = function(v) {
    return function(v1) {
      if (v instanceof Just) {
        return v1(v.value0);
      }
      ;
      return pure14(false);
    };
  };
  var sendToPos = function(a2) {
    return function(state4) {
      return function __do2() {
        var scope2 = getScope(a2.id)(state4)();
        var parent2 = getParent(a2.id)(state4)();
        var dynFamily = getDynFamily(a2.id)(state4)();
        var newA = {
          scope: scope2,
          parent: parent2,
          dynFamily,
          id: a2.id,
          pos: new Just(a2.pos),
          ez: false,
          raiseId: mempty3,
          ctor: envy(empty9)
        };
        return coerce5(giveNewParent_(Just.create)(runOnJust)(newA))(state4)();
      };
    };
  };
  var __internalDekuFlatten3 = function(a2) {
    return function(b2) {
      return function(c) {
        return flatten({
          doLogic: function(pos) {
            return function(v) {
              return function(id) {
                return v.sendToPos({
                  id,
                  pos
                });
              };
            };
          },
          ids: function($82) {
            return function(v) {
              return v.ids;
            }(unwrap4($82));
          },
          disconnectElement: function(v) {
            return function(v1) {
              return v.disconnectElement({
                id: v1.id,
                scope: v1.scope,
                parent: v1.parent,
                scopeEq: eq4
              });
            };
          },
          toElt: function(v) {
            return v;
          }
        })(a2)(b2)(coerce5(c));
      };
    };
  };
  var giveNewParentOrReconstruct = function(di) {
    return function(just) {
      return function(roj) {
        return function(gnp) {
          return join2(liftF(pure23(function(ffi) {
            var needsFreshNut = function() {
              var v = map9(function(a2) {
                return function(v1) {
                  return pure14(a2);
                };
              })(__internalDekuFlatten3({
                dynFamily: gnp.dynFamily,
                ez: gnp.ez,
                parent: new Just(gnp.parent),
                pos: gnp.pos,
                raiseId: gnp.raiseId,
                scope: gnp.scope
              })(di)(gnp.ctor));
              return pure14(wrap2(v));
            }();
            var hasIdAndInScope = pure14(liftF(pure23(giveNewParent_(just)(roj)(gnp))));
            return function __do2() {
              var hasId = stateHasKey(gnp.id)(ffi)();
              if (hasId) {
                var scope2 = getScope(gnp.id)(ffi)();
                if (scope2 instanceof Global) {
                  return hasIdAndInScope();
                }
                ;
                if (scope2 instanceof Local && gnp.scope instanceof Local) {
                  var $79 = includes(scope2.value0)(gnp.scope.value0);
                  if ($79) {
                    return hasIdAndInScope();
                  }
                  ;
                  return needsFreshNut();
                }
                ;
                return needsFreshNut();
              }
              ;
              return needsFreshNut();
            };
          })));
        };
      };
    };
  };
  var fullDOMInterpret = function(seed) {
    var l = {
      ids: function __do2() {
        var s2 = read(seed)();
        var o = show2(evalGen(arbitrary2)({
          newSeed: mkSeed(s2),
          size: 5
        }));
        $$void5(modify2(add3(1))(seed))();
        return o;
      },
      makeElement: function() {
        var $83 = makeElement_(runOnJust)(false);
        return function($84) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($83($84))));
        };
      }(),
      makeDynBeacon: function() {
        var $85 = makeDynBeacon_(runOnJust)(false);
        return function($86) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($85($86))));
        };
      }(),
      attributeParent: function() {
        var $87 = attributeParent_(runOnJust);
        return function($88) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($87($88))));
        };
      }(),
      makeRoot: function($89) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(makeRoot_($89))));
      },
      makeText: function() {
        var $90 = makeText_(runOnJust)(false)(maybe(unit));
        return function($91) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($90($91))));
        };
      }(),
      makePursx: function() {
        var $92 = makePursx_(runOnJust)(false)(maybe(unit));
        return function($93) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($92($93))));
        };
      }(),
      setProp: function() {
        var $94 = setProp_(false);
        return function($95) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($94($95))));
        };
      }(),
      setCb: function() {
        var $96 = setCb_(false);
        return function($97) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($96($97))));
        };
      }(),
      unsetAttribute: function() {
        var $98 = unsetAttribute_(false);
        return function($99) {
          return liftF(EFunctionOfFFIDOMSnapshot(pure23($98($99))));
        };
      }(),
      setText: function($100) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(setText_($100))));
      },
      sendToPos: function($101) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(sendToPos($101))));
      },
      removeDynBeacon: function($102) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(removeDynBeacon_($102))));
      },
      deleteFromCache: function($103) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(deleteFromCache_($103))));
      },
      giveNewParent: function(gnp) {
        return giveNewParentOrReconstruct(l)(Just.create)(runOnJust)(gnp);
      },
      disconnectElement: function($104) {
        return liftF(EFunctionOfFFIDOMSnapshot(pure23(disconnectElement_($104))));
      }
    };
    return l;
  };

  // output/Web.HTML/foreign.js
  var windowImpl = function() {
    return window;
  };

  // output/Web.Internal.FFI/foreign.js
  function _unsafeReadProtoTagged(nothing, just, name15, value12) {
    if (typeof window !== "undefined") {
      var ty = window[name15];
      if (ty != null && value12 instanceof ty) {
        return just(value12);
      }
    }
    var obj = value12;
    while (obj != null) {
      var proto = Object.getPrototypeOf(obj);
      var constructorName = proto.constructor.name;
      if (constructorName === name15) {
        return just(value12);
      } else if (constructorName === "Object") {
        return nothing;
      }
      obj = proto;
    }
    return nothing;
  }

  // output/Web.Internal.FFI/index.js
  var unsafeReadProtoTagged = function(name15) {
    return function(value12) {
      return _unsafeReadProtoTagged(Nothing.value, Just.create, name15, value12);
    };
  };

  // output/Data.Nullable/foreign.js
  function nullable(a2, r, f) {
    return a2 == null ? r : f(a2);
  }

  // output/Data.Nullable/index.js
  var toMaybe = function(n) {
    return nullable(n, Nothing.value, Just.create);
  };

  // output/Web.HTML.HTMLDocument/foreign.js
  function _body(doc) {
    return doc.body;
  }

  // output/Web.HTML.HTMLDocument/index.js
  var map10 = /* @__PURE__ */ map(functorEffect);
  var body = function(doc) {
    return map10(toMaybe)(function() {
      return _body(doc);
    });
  };

  // output/Web.HTML.HTMLElement/index.js
  var toElement = unsafeCoerce2;

  // output/Web.HTML.Window/foreign.js
  function document2(window2) {
    return function() {
      return window2.document;
    };
  }

  // output/Deku.Toplevel/index.js
  var keepLatest5 = /* @__PURE__ */ keepLatest(eventIsEvent);
  var map11 = /* @__PURE__ */ map(functorEvent);
  var resume2 = /* @__PURE__ */ resume(functorEFunctionOfFFIDOMS);
  var monoidEffect3 = /* @__PURE__ */ monoidEffect(monoidUnit);
  var mempty4 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidEvent(/* @__PURE__ */ monoidFn(monoidEffect3)));
  var pure9 = /* @__PURE__ */ pure(applicativeEffect);
  var bind3 = /* @__PURE__ */ bind(bindEffect);
  var mapFlipped2 = /* @__PURE__ */ mapFlipped(functorEffect);
  var liftST3 = /* @__PURE__ */ liftST(monadSTEffect);
  var mempty12 = /* @__PURE__ */ mempty(/* @__PURE__ */ monoidEffect(monoidEffect3));
  var map15 = /* @__PURE__ */ map(functorMaybe);
  var $$void6 = /* @__PURE__ */ $$void(functorEffect);
  var flattenToSingleEvent = function(ffi) {
    var go$prime = function(n) {
      var $52 = map11(go2(n));
      return function($53) {
        return keepLatest5($52($53));
      };
    };
    var go2 = function(n) {
      return function($54) {
        return function(v) {
          if (v instanceof Left) {
            return keepLatest5(map11(f(n))(v.value0));
          }
          ;
          if (v instanceof Right) {
            return mempty4;
          }
          ;
          throw new Error("Failed pattern match at Deku.Toplevel (line 47, column 21 - line 49, column 22): " + [v.constructor.name]);
        }(resume2($54));
      };
    };
    var f = function(n) {
      return function(i2) {
        return go$prime(n + 1 | 0)(makeEvent(function(k) {
          return function __do2() {
            unit;
            bind3(i2(ffi))(k)();
            return pure9(unit);
          };
        }));
      };
    };
    return go$prime(0);
  };
  var runInElement$prime = function(elt) {
    return function(eee) {
      return function __do2() {
        var ffi = makeFFIDOMSnapshot();
        var evt = mapFlipped2(liftST3(newSTRef(0)))(function() {
          var $55 = deku(elt)(eee);
          return function($56) {
            return $55(fullDOMInterpret($56));
          };
        }())();
        return subscribe(flattenToSingleEvent(ffi)(evt))(function(i2) {
          return i2(ffi);
        })();
      };
    };
  };
  var runInBody$prime = function(eee) {
    return function __do2() {
      var b$prime = bind3(bind3(windowImpl)(document2))(body)();
      return maybe(mempty12)(function(elt) {
        return runInElement$prime(elt)(eee);
      })(map15(toElement)(b$prime))();
    };
  };
  var runInBody = function(a2) {
    return $$void6(runInBody$prime(a2));
  };

  // output/Deku.DOM.Attr.Class/index.js
  var Class = /* @__PURE__ */ function() {
    function Class2() {
    }
    ;
    Class2.value = new Class2();
    return Class2;
  }();
  var attrPre_ClassString = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "class",
          value: prop$prime(value12)
        });
      };
    }
  };
  var attrDiv_ClassString = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "class",
          value: prop$prime(value12)
        });
      };
    }
  };

  // output/Deku.DOM.Attr.Contenteditable/index.js
  var Contenteditable = /* @__PURE__ */ function() {
    function Contenteditable2() {
    }
    ;
    Contenteditable2.value = new Contenteditable2();
    return Contenteditable2;
  }();
  var attrPre_ContenteditableSt = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "contenteditable",
          value: prop$prime(value12)
        });
      };
    }
  };

  // output/Deku.DOM.Attr.OnAuxclick/index.js
  var OnAuxclick = /* @__PURE__ */ function() {
    function OnAuxclick2() {
    }
    ;
    OnAuxclick2.value = new OnAuxclick2();
    return OnAuxclick2;
  }();
  var attrOnAuxclickCb = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "auxclick ",
          value: cb$prime(value12)
        });
      };
    }
  };

  // output/Deku.DOM.Elt.Pre/index.js
  var pre = /* @__PURE__ */ elementify2("pre");

  // output/Deku.Do/index.js
  var bind4 = function(f) {
    return function(a2) {
      return f(a2);
    };
  };

  // output/Effect.Aff/foreign.js
  var Aff = function() {
    var EMPTY = {};
    var PURE = "Pure";
    var THROW = "Throw";
    var CATCH = "Catch";
    var SYNC = "Sync";
    var ASYNC = "Async";
    var BIND = "Bind";
    var BRACKET = "Bracket";
    var FORK = "Fork";
    var SEQ = "Sequential";
    var MAP = "Map";
    var APPLY = "Apply";
    var ALT = "Alt";
    var CONS = "Cons";
    var RESUME = "Resume";
    var RELEASE = "Release";
    var FINALIZER = "Finalizer";
    var FINALIZED = "Finalized";
    var FORKED = "Forked";
    var FIBER = "Fiber";
    var THUNK = "Thunk";
    function Aff2(tag, _1, _2, _3) {
      this.tag = tag;
      this._1 = _1;
      this._2 = _2;
      this._3 = _3;
    }
    function AffCtr(tag) {
      var fn = function(_1, _2, _3) {
        return new Aff2(tag, _1, _2, _3);
      };
      fn.tag = tag;
      return fn;
    }
    function nonCanceler(error3) {
      return new Aff2(PURE, void 0);
    }
    function runEff(eff) {
      try {
        eff();
      } catch (error3) {
        setTimeout(function() {
          throw error3;
        }, 0);
      }
    }
    function runSync(left2, right2, eff) {
      try {
        return right2(eff());
      } catch (error3) {
        return left2(error3);
      }
    }
    function runAsync(left2, eff, k) {
      try {
        return eff(k)();
      } catch (error3) {
        k(left2(error3))();
        return nonCanceler;
      }
    }
    var Scheduler = function() {
      var limit = 1024;
      var size5 = 0;
      var ix = 0;
      var queue = new Array(limit);
      var draining = false;
      function drain() {
        var thunk;
        draining = true;
        while (size5 !== 0) {
          size5--;
          thunk = queue[ix];
          queue[ix] = void 0;
          ix = (ix + 1) % limit;
          thunk();
        }
        draining = false;
      }
      return {
        isDraining: function() {
          return draining;
        },
        enqueue: function(cb2) {
          var i2, tmp;
          if (size5 === limit) {
            tmp = draining;
            drain();
            draining = tmp;
          }
          queue[(ix + size5) % limit] = cb2;
          size5++;
          if (!draining) {
            drain();
          }
        }
      };
    }();
    function Supervisor(util) {
      var fibers = {};
      var fiberId = 0;
      var count2 = 0;
      return {
        register: function(fiber) {
          var fid = fiberId++;
          fiber.onComplete({
            rethrow: true,
            handler: function(result) {
              return function() {
                count2--;
                delete fibers[fid];
              };
            }
          })();
          fibers[fid] = fiber;
          count2++;
        },
        isEmpty: function() {
          return count2 === 0;
        },
        killAll: function(killError, cb2) {
          return function() {
            if (count2 === 0) {
              return cb2();
            }
            var killCount = 0;
            var kills = {};
            function kill(fid) {
              kills[fid] = fibers[fid].kill(killError, function(result) {
                return function() {
                  delete kills[fid];
                  killCount--;
                  if (util.isLeft(result) && util.fromLeft(result)) {
                    setTimeout(function() {
                      throw util.fromLeft(result);
                    }, 0);
                  }
                  if (killCount === 0) {
                    cb2();
                  }
                };
              })();
            }
            for (var k in fibers) {
              if (fibers.hasOwnProperty(k)) {
                killCount++;
                kill(k);
              }
            }
            fibers = {};
            fiberId = 0;
            count2 = 0;
            return function(error3) {
              return new Aff2(SYNC, function() {
                for (var k2 in kills) {
                  if (kills.hasOwnProperty(k2)) {
                    kills[k2]();
                  }
                }
              });
            };
          };
        }
      };
    }
    var SUSPENDED = 0;
    var CONTINUE = 1;
    var STEP_BIND = 2;
    var STEP_RESULT = 3;
    var PENDING = 4;
    var RETURN = 5;
    var COMPLETED = 6;
    function Fiber(util, supervisor, aff) {
      var runTick = 0;
      var status = SUSPENDED;
      var step3 = aff;
      var fail = null;
      var interrupt = null;
      var bhead = null;
      var btail = null;
      var attempts = null;
      var bracketCount = 0;
      var joinId = 0;
      var joins = null;
      var rethrow = true;
      function run3(localRunTick) {
        var tmp, result, attempt;
        while (true) {
          tmp = null;
          result = null;
          attempt = null;
          switch (status) {
            case STEP_BIND:
              status = CONTINUE;
              try {
                step3 = bhead(step3);
                if (btail === null) {
                  bhead = null;
                } else {
                  bhead = btail._1;
                  btail = btail._2;
                }
              } catch (e) {
                status = RETURN;
                fail = util.left(e);
                step3 = null;
              }
              break;
            case STEP_RESULT:
              if (util.isLeft(step3)) {
                status = RETURN;
                fail = step3;
                step3 = null;
              } else if (bhead === null) {
                status = RETURN;
              } else {
                status = STEP_BIND;
                step3 = util.fromRight(step3);
              }
              break;
            case CONTINUE:
              switch (step3.tag) {
                case BIND:
                  if (bhead) {
                    btail = new Aff2(CONS, bhead, btail);
                  }
                  bhead = step3._2;
                  status = CONTINUE;
                  step3 = step3._1;
                  break;
                case PURE:
                  if (bhead === null) {
                    status = RETURN;
                    step3 = util.right(step3._1);
                  } else {
                    status = STEP_BIND;
                    step3 = step3._1;
                  }
                  break;
                case SYNC:
                  status = STEP_RESULT;
                  step3 = runSync(util.left, util.right, step3._1);
                  break;
                case ASYNC:
                  status = PENDING;
                  step3 = runAsync(util.left, step3._1, function(result2) {
                    return function() {
                      if (runTick !== localRunTick) {
                        return;
                      }
                      runTick++;
                      Scheduler.enqueue(function() {
                        if (runTick !== localRunTick + 1) {
                          return;
                        }
                        status = STEP_RESULT;
                        step3 = result2;
                        run3(runTick);
                      });
                    };
                  });
                  return;
                case THROW:
                  status = RETURN;
                  fail = util.left(step3._1);
                  step3 = null;
                  break;
                case CATCH:
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step3, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step3, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status = CONTINUE;
                  step3 = step3._1;
                  break;
                case BRACKET:
                  bracketCount++;
                  if (bhead === null) {
                    attempts = new Aff2(CONS, step3, attempts, interrupt);
                  } else {
                    attempts = new Aff2(CONS, step3, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                  }
                  bhead = null;
                  btail = null;
                  status = CONTINUE;
                  step3 = step3._1;
                  break;
                case FORK:
                  status = STEP_RESULT;
                  tmp = Fiber(util, supervisor, step3._2);
                  if (supervisor) {
                    supervisor.register(tmp);
                  }
                  if (step3._1) {
                    tmp.run();
                  }
                  step3 = util.right(tmp);
                  break;
                case SEQ:
                  status = CONTINUE;
                  step3 = sequential2(util, supervisor, step3._1);
                  break;
              }
              break;
            case RETURN:
              bhead = null;
              btail = null;
              if (attempts === null) {
                status = COMPLETED;
                step3 = interrupt || fail || step3;
              } else {
                tmp = attempts._3;
                attempt = attempts._1;
                attempts = attempts._2;
                switch (attempt.tag) {
                  case CATCH:
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      status = RETURN;
                    } else if (fail) {
                      status = CONTINUE;
                      step3 = attempt._2(util.fromLeft(fail));
                      fail = null;
                    }
                    break;
                  case RESUME:
                    if (interrupt && interrupt !== tmp && bracketCount === 0 || fail) {
                      status = RETURN;
                    } else {
                      bhead = attempt._1;
                      btail = attempt._2;
                      status = STEP_BIND;
                      step3 = util.fromRight(step3);
                    }
                    break;
                  case BRACKET:
                    bracketCount--;
                    if (fail === null) {
                      result = util.fromRight(step3);
                      attempts = new Aff2(CONS, new Aff2(RELEASE, attempt._2, result), attempts, tmp);
                      if (interrupt === tmp || bracketCount > 0) {
                        status = CONTINUE;
                        step3 = attempt._3(result);
                      }
                    }
                    break;
                  case RELEASE:
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step3, fail), attempts, interrupt);
                    status = CONTINUE;
                    if (interrupt && interrupt !== tmp && bracketCount === 0) {
                      step3 = attempt._1.killed(util.fromLeft(interrupt))(attempt._2);
                    } else if (fail) {
                      step3 = attempt._1.failed(util.fromLeft(fail))(attempt._2);
                    } else {
                      step3 = attempt._1.completed(util.fromRight(step3))(attempt._2);
                    }
                    fail = null;
                    bracketCount++;
                    break;
                  case FINALIZER:
                    bracketCount++;
                    attempts = new Aff2(CONS, new Aff2(FINALIZED, step3, fail), attempts, interrupt);
                    status = CONTINUE;
                    step3 = attempt._1;
                    break;
                  case FINALIZED:
                    bracketCount--;
                    status = RETURN;
                    step3 = attempt._1;
                    fail = attempt._2;
                    break;
                }
              }
              break;
            case COMPLETED:
              for (var k in joins) {
                if (joins.hasOwnProperty(k)) {
                  rethrow = rethrow && joins[k].rethrow;
                  runEff(joins[k].handler(step3));
                }
              }
              joins = null;
              if (interrupt && fail) {
                setTimeout(function() {
                  throw util.fromLeft(fail);
                }, 0);
              } else if (util.isLeft(step3) && rethrow) {
                setTimeout(function() {
                  if (rethrow) {
                    throw util.fromLeft(step3);
                  }
                }, 0);
              }
              return;
            case SUSPENDED:
              status = CONTINUE;
              break;
            case PENDING:
              return;
          }
        }
      }
      function onComplete(join4) {
        return function() {
          if (status === COMPLETED) {
            rethrow = rethrow && join4.rethrow;
            join4.handler(step3)();
            return function() {
            };
          }
          var jid = joinId++;
          joins = joins || {};
          joins[jid] = join4;
          return function() {
            if (joins !== null) {
              delete joins[jid];
            }
          };
        };
      }
      function kill(error3, cb2) {
        return function() {
          if (status === COMPLETED) {
            cb2(util.right(void 0))();
            return function() {
            };
          }
          var canceler = onComplete({
            rethrow: false,
            handler: function() {
              return cb2(util.right(void 0));
            }
          })();
          switch (status) {
            case SUSPENDED:
              interrupt = util.left(error3);
              status = COMPLETED;
              step3 = interrupt;
              run3(runTick);
              break;
            case PENDING:
              if (interrupt === null) {
                interrupt = util.left(error3);
              }
              if (bracketCount === 0) {
                if (status === PENDING) {
                  attempts = new Aff2(CONS, new Aff2(FINALIZER, step3(error3)), attempts, interrupt);
                }
                status = RETURN;
                step3 = null;
                fail = null;
                run3(++runTick);
              }
              break;
            default:
              if (interrupt === null) {
                interrupt = util.left(error3);
              }
              if (bracketCount === 0) {
                status = RETURN;
                step3 = null;
                fail = null;
              }
          }
          return canceler;
        };
      }
      function join3(cb2) {
        return function() {
          var canceler = onComplete({
            rethrow: false,
            handler: cb2
          })();
          if (status === SUSPENDED) {
            run3(runTick);
          }
          return canceler;
        };
      }
      return {
        kill,
        join: join3,
        onComplete,
        isSuspended: function() {
          return status === SUSPENDED;
        },
        run: function() {
          if (status === SUSPENDED) {
            if (!Scheduler.isDraining()) {
              Scheduler.enqueue(function() {
                run3(runTick);
              });
            } else {
              run3(runTick);
            }
          }
        }
      };
    }
    function runPar(util, supervisor, par, cb2) {
      var fiberId = 0;
      var fibers = {};
      var killId = 0;
      var kills = {};
      var early = new Error("[ParAff] Early exit");
      var interrupt = null;
      var root = EMPTY;
      function kill(error3, par2, cb3) {
        var step3 = par2;
        var head5 = null;
        var tail2 = null;
        var count2 = 0;
        var kills2 = {};
        var tmp, kid;
        loop:
          while (true) {
            tmp = null;
            switch (step3.tag) {
              case FORKED:
                if (step3._3 === EMPTY) {
                  tmp = fibers[step3._1];
                  kills2[count2++] = tmp.kill(error3, function(result) {
                    return function() {
                      count2--;
                      if (count2 === 0) {
                        cb3(result)();
                      }
                    };
                  });
                }
                if (head5 === null) {
                  break loop;
                }
                step3 = head5._2;
                if (tail2 === null) {
                  head5 = null;
                } else {
                  head5 = tail2._1;
                  tail2 = tail2._2;
                }
                break;
              case MAP:
                step3 = step3._2;
                break;
              case APPLY:
              case ALT:
                if (head5) {
                  tail2 = new Aff2(CONS, head5, tail2);
                }
                head5 = step3;
                step3 = step3._1;
                break;
            }
          }
        if (count2 === 0) {
          cb3(util.right(void 0))();
        } else {
          kid = 0;
          tmp = count2;
          for (; kid < tmp; kid++) {
            kills2[kid] = kills2[kid]();
          }
        }
        return kills2;
      }
      function join3(result, head5, tail2) {
        var fail, step3, lhs, rhs, tmp, kid;
        if (util.isLeft(result)) {
          fail = result;
          step3 = null;
        } else {
          step3 = result;
          fail = null;
        }
        loop:
          while (true) {
            lhs = null;
            rhs = null;
            tmp = null;
            kid = null;
            if (interrupt !== null) {
              return;
            }
            if (head5 === null) {
              cb2(fail || step3)();
              return;
            }
            if (head5._3 !== EMPTY) {
              return;
            }
            switch (head5.tag) {
              case MAP:
                if (fail === null) {
                  head5._3 = util.right(head5._1(util.fromRight(step3)));
                  step3 = head5._3;
                } else {
                  head5._3 = fail;
                }
                break;
              case APPLY:
                lhs = head5._1._3;
                rhs = head5._2._3;
                if (fail) {
                  head5._3 = fail;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, fail === lhs ? head5._2 : head5._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail2 === null) {
                        join3(fail, null, null);
                      } else {
                        join3(fail, tail2._1, tail2._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                } else if (lhs === EMPTY || rhs === EMPTY) {
                  return;
                } else {
                  step3 = util.right(util.fromRight(lhs)(util.fromRight(rhs)));
                  head5._3 = step3;
                }
                break;
              case ALT:
                lhs = head5._1._3;
                rhs = head5._2._3;
                if (lhs === EMPTY && util.isLeft(rhs) || rhs === EMPTY && util.isLeft(lhs)) {
                  return;
                }
                if (lhs !== EMPTY && util.isLeft(lhs) && rhs !== EMPTY && util.isLeft(rhs)) {
                  fail = step3 === lhs ? rhs : lhs;
                  step3 = null;
                  head5._3 = fail;
                } else {
                  head5._3 = step3;
                  tmp = true;
                  kid = killId++;
                  kills[kid] = kill(early, step3 === lhs ? head5._2 : head5._1, function() {
                    return function() {
                      delete kills[kid];
                      if (tmp) {
                        tmp = false;
                      } else if (tail2 === null) {
                        join3(step3, null, null);
                      } else {
                        join3(step3, tail2._1, tail2._2);
                      }
                    };
                  });
                  if (tmp) {
                    tmp = false;
                    return;
                  }
                }
                break;
            }
            if (tail2 === null) {
              head5 = null;
            } else {
              head5 = tail2._1;
              tail2 = tail2._2;
            }
          }
      }
      function resolve(fiber) {
        return function(result) {
          return function() {
            delete fibers[fiber._1];
            fiber._3 = result;
            join3(result, fiber._2._1, fiber._2._2);
          };
        };
      }
      function run3() {
        var status = CONTINUE;
        var step3 = par;
        var head5 = null;
        var tail2 = null;
        var tmp, fid;
        loop:
          while (true) {
            tmp = null;
            fid = null;
            switch (status) {
              case CONTINUE:
                switch (step3.tag) {
                  case MAP:
                    if (head5) {
                      tail2 = new Aff2(CONS, head5, tail2);
                    }
                    head5 = new Aff2(MAP, step3._1, EMPTY, EMPTY);
                    step3 = step3._2;
                    break;
                  case APPLY:
                    if (head5) {
                      tail2 = new Aff2(CONS, head5, tail2);
                    }
                    head5 = new Aff2(APPLY, EMPTY, step3._2, EMPTY);
                    step3 = step3._1;
                    break;
                  case ALT:
                    if (head5) {
                      tail2 = new Aff2(CONS, head5, tail2);
                    }
                    head5 = new Aff2(ALT, EMPTY, step3._2, EMPTY);
                    step3 = step3._1;
                    break;
                  default:
                    fid = fiberId++;
                    status = RETURN;
                    tmp = step3;
                    step3 = new Aff2(FORKED, fid, new Aff2(CONS, head5, tail2), EMPTY);
                    tmp = Fiber(util, supervisor, tmp);
                    tmp.onComplete({
                      rethrow: false,
                      handler: resolve(step3)
                    })();
                    fibers[fid] = tmp;
                    if (supervisor) {
                      supervisor.register(tmp);
                    }
                }
                break;
              case RETURN:
                if (head5 === null) {
                  break loop;
                }
                if (head5._1 === EMPTY) {
                  head5._1 = step3;
                  status = CONTINUE;
                  step3 = head5._2;
                  head5._2 = EMPTY;
                } else {
                  head5._2 = step3;
                  step3 = head5;
                  if (tail2 === null) {
                    head5 = null;
                  } else {
                    head5 = tail2._1;
                    tail2 = tail2._2;
                  }
                }
            }
          }
        root = step3;
        for (fid = 0; fid < fiberId; fid++) {
          fibers[fid].run();
        }
      }
      function cancel(error3, cb3) {
        interrupt = util.left(error3);
        var innerKills;
        for (var kid in kills) {
          if (kills.hasOwnProperty(kid)) {
            innerKills = kills[kid];
            for (kid in innerKills) {
              if (innerKills.hasOwnProperty(kid)) {
                innerKills[kid]();
              }
            }
          }
        }
        kills = null;
        var newKills = kill(error3, root, cb3);
        return function(killError) {
          return new Aff2(ASYNC, function(killCb) {
            return function() {
              for (var kid2 in newKills) {
                if (newKills.hasOwnProperty(kid2)) {
                  newKills[kid2]();
                }
              }
              return nonCanceler;
            };
          });
        };
      }
      run3();
      return function(killError) {
        return new Aff2(ASYNC, function(killCb) {
          return function() {
            return cancel(killError, killCb);
          };
        });
      };
    }
    function sequential2(util, supervisor, par) {
      return new Aff2(ASYNC, function(cb2) {
        return function() {
          return runPar(util, supervisor, par, cb2);
        };
      });
    }
    Aff2.EMPTY = EMPTY;
    Aff2.Pure = AffCtr(PURE);
    Aff2.Throw = AffCtr(THROW);
    Aff2.Catch = AffCtr(CATCH);
    Aff2.Sync = AffCtr(SYNC);
    Aff2.Async = AffCtr(ASYNC);
    Aff2.Bind = AffCtr(BIND);
    Aff2.Bracket = AffCtr(BRACKET);
    Aff2.Fork = AffCtr(FORK);
    Aff2.Seq = AffCtr(SEQ);
    Aff2.ParMap = AffCtr(MAP);
    Aff2.ParApply = AffCtr(APPLY);
    Aff2.ParAlt = AffCtr(ALT);
    Aff2.Fiber = Fiber;
    Aff2.Supervisor = Supervisor;
    Aff2.Scheduler = Scheduler;
    Aff2.nonCanceler = nonCanceler;
    return Aff2;
  }();
  var _pure = Aff.Pure;
  var _throwError = Aff.Throw;
  var _liftEffect = Aff.Sync;
  var makeAff = Aff.Async;
  var _delay = function() {
    function setDelay(n, k) {
      if (n === 0 && typeof setImmediate !== "undefined") {
        return setImmediate(k);
      } else {
        return setTimeout(k, n);
      }
    }
    function clearDelay(n, t) {
      if (n === 0 && typeof clearImmediate !== "undefined") {
        return clearImmediate(t);
      } else {
        return clearTimeout(t);
      }
    }
    return function(right2, ms) {
      return Aff.Async(function(cb2) {
        return function() {
          var timer = setDelay(ms, cb2(right2()));
          return function() {
            return Aff.Sync(function() {
              return right2(clearDelay(ms, timer));
            });
          };
        };
      });
    };
  }();
  var _sequential = Aff.Seq;

  // output/Deku.Hooks/index.js
  var map16 = /* @__PURE__ */ map(functorEvent);
  var alt6 = /* @__PURE__ */ alt(altEvent);
  var pure10 = /* @__PURE__ */ pure(applicativeEvent);
  var useState$prime = bussedUncurried;
  var useMemoized = function(e) {
    return function(f1) {
      var ee = memoize(e)(f1);
      var eee = map16(function(v) {
        return v;
      })(ee);
      var eeee = envy(map16(function(v) {
        return v;
      })(eee));
      return eeee;
    };
  };
  var useState = function(a2) {
    return function(f) {
      return bind4(useState$prime)(function(v) {
        return bind4(useMemoized(alt6(v.value1)(pure10(a2))))(function(m) {
          return f(new Tuple(v.value0, m));
        });
      });
    };
  };

  // output/Deku.DOM.Attr.Id/index.js
  var Id = /* @__PURE__ */ function() {
    function Id2() {
    }
    ;
    Id2.value = new Id2();
    return Id2;
  }();
  var attrDiv_IdString = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "id",
          value: prop$prime(value12)
        });
      };
    }
  };

  // output/Deku.DOM.Attr.OnKeydown/index.js
  var OnKeydown = /* @__PURE__ */ function() {
    function OnKeydown2() {
    }
    ;
    OnKeydown2.value = new OnKeydown2();
    return OnKeydown2;
  }();
  var attrOnKeydownCb = {
    attr: function(v) {
      return function(value12) {
        return unsafeAttribute({
          key: "keydown",
          value: cb$prime(value12)
        });
      };
    }
  };

  // output/Web.Event.Event/foreign.js
  function preventDefault(e) {
    return function() {
      return e.preventDefault();
    };
  }

  // output/Web.UIEvent.KeyboardEvent/foreign.js
  function key(e) {
    return e.key;
  }
  function code2(e) {
    return e.code;
  }
  function ctrlKey(e) {
    return e.ctrlKey;
  }
  function shiftKey(e) {
    return e.shiftKey;
  }

  // output/Web.UIEvent.KeyboardEvent/index.js
  var fromEvent = /* @__PURE__ */ unsafeReadProtoTagged("KeyboardEvent");

  // output/Deku.Listeners/index.js
  var for_4 = /* @__PURE__ */ for_(applicativeEffect)(foldableMaybe);
  var keyEvent$prime = function(dictFunctor) {
    var map18 = map(dictFunctor);
    return function(dictAttr) {
      var attr2 = attr(dictAttr);
      return function(listener) {
        return map18(function(f) {
          return attr2(listener)(cb(function(e) {
            return for_4(fromEvent(e))(f);
          }));
        });
      };
    };
  };
  var keyEvent$prime1 = /* @__PURE__ */ keyEvent$prime(functorEvent);
  var keyDown = /* @__PURE__ */ function() {
    return keyEvent$prime1(attrOnKeydownCb)(OnKeydown.value);
  }();

  // output/Editor.Keyboard/index.js
  var SpaceKey = /* @__PURE__ */ function() {
    function SpaceKey2() {
    }
    ;
    SpaceKey2.value = new SpaceKey2();
    return SpaceKey2;
  }();
  var Left2 = /* @__PURE__ */ function() {
    function Left3() {
    }
    ;
    Left3.value = new Left3();
    return Left3;
  }();
  var Right2 = /* @__PURE__ */ function() {
    function Right3() {
    }
    ;
    Right3.value = new Right3();
    return Right3;
  }();
  var Up = /* @__PURE__ */ function() {
    function Up2() {
    }
    ;
    Up2.value = new Up2();
    return Up2;
  }();
  var Down = /* @__PURE__ */ function() {
    function Down2() {
    }
    ;
    Down2.value = new Down2();
    return Down2;
  }();
  var Shift = /* @__PURE__ */ function() {
    function Shift2() {
    }
    ;
    Shift2.value = new Shift2();
    return Shift2;
  }();
  var Control = /* @__PURE__ */ function() {
    function Control2() {
    }
    ;
    Control2.value = new Control2();
    return Control2;
  }();
  var Alt2 = /* @__PURE__ */ function() {
    function Alt3() {
    }
    ;
    Alt3.value = new Alt3();
    return Alt3;
  }();
  var Tab = /* @__PURE__ */ function() {
    function Tab2() {
    }
    ;
    Tab2.value = new Tab2();
    return Tab2;
  }();
  var ShiftTab = /* @__PURE__ */ function() {
    function ShiftTab2() {
    }
    ;
    ShiftTab2.value = new ShiftTab2();
    return ShiftTab2;
  }();
  var CapsLock = /* @__PURE__ */ function() {
    function CapsLock2() {
    }
    ;
    CapsLock2.value = new CapsLock2();
    return CapsLock2;
  }();
  var Escape = /* @__PURE__ */ function() {
    function Escape2() {
    }
    ;
    Escape2.value = new Escape2();
    return Escape2;
  }();
  var Enter = /* @__PURE__ */ function() {
    function Enter2() {
    }
    ;
    Enter2.value = new Enter2();
    return Enter2;
  }();
  var ShiftEnter = /* @__PURE__ */ function() {
    function ShiftEnter2() {
    }
    ;
    ShiftEnter2.value = new ShiftEnter2();
    return ShiftEnter2;
  }();
  var PageUp = /* @__PURE__ */ function() {
    function PageUp2() {
    }
    ;
    PageUp2.value = new PageUp2();
    return PageUp2;
  }();
  var PageDown = /* @__PURE__ */ function() {
    function PageDown2() {
    }
    ;
    PageDown2.value = new PageDown2();
    return PageDown2;
  }();
  var GoToStartOfLine = /* @__PURE__ */ function() {
    function GoToStartOfLine2() {
    }
    ;
    GoToStartOfLine2.value = new GoToStartOfLine2();
    return GoToStartOfLine2;
  }();
  var GoToEndOfLine = /* @__PURE__ */ function() {
    function GoToEndOfLine2() {
    }
    ;
    GoToEndOfLine2.value = new GoToEndOfLine2();
    return GoToEndOfLine2;
  }();
  var GoToStartOfWord = /* @__PURE__ */ function() {
    function GoToStartOfWord2() {
    }
    ;
    GoToStartOfWord2.value = new GoToStartOfWord2();
    return GoToStartOfWord2;
  }();
  var GoToEndOfWord = /* @__PURE__ */ function() {
    function GoToEndOfWord2() {
    }
    ;
    GoToEndOfWord2.value = new GoToEndOfWord2();
    return GoToEndOfWord2;
  }();
  var Undo = /* @__PURE__ */ function() {
    function Undo2() {
    }
    ;
    Undo2.value = new Undo2();
    return Undo2;
  }();
  var Redo = /* @__PURE__ */ function() {
    function Redo2() {
    }
    ;
    Redo2.value = new Redo2();
    return Redo2;
  }();
  var SelectAll = /* @__PURE__ */ function() {
    function SelectAll2() {
    }
    ;
    SelectAll2.value = new SelectAll2();
    return SelectAll2;
  }();
  var Backspace = /* @__PURE__ */ function() {
    function Backspace2() {
    }
    ;
    Backspace2.value = new Backspace2();
    return Backspace2;
  }();
  var Copy = /* @__PURE__ */ function() {
    function Copy2() {
    }
    ;
    Copy2.value = new Copy2();
    return Copy2;
  }();
  var Paste = /* @__PURE__ */ function() {
    function Paste2() {
    }
    ;
    Paste2.value = new Paste2();
    return Paste2;
  }();
  var Save = /* @__PURE__ */ function() {
    function Save2() {
    }
    ;
    Save2.value = new Save2();
    return Save2;
  }();
  var Yank = /* @__PURE__ */ function() {
    function Yank2() {
    }
    ;
    Yank2.value = new Yank2();
    return Yank2;
  }();
  var Unhandled = /* @__PURE__ */ function() {
    function Unhandled2(value0) {
      this.value0 = value0;
    }
    ;
    Unhandled2.create = function(value0) {
      return new Unhandled2(value0);
    };
    return Unhandled2;
  }();
  var keyAction = function(e) {
    var isShift = shiftKey(e);
    var isCtrl = ctrlKey(e);
    var k = function() {
      if (isCtrl || isShift && isCtrl) {
        var k2 = function() {
          if (key(e) === "a") {
            return SelectAll.value;
          }
          ;
          if (key(e) === "y") {
            return Redo.value;
          }
          ;
          if (key(e) === "z") {
            return Undo.value;
          }
          ;
          if (key(e) === "s") {
            return Save.value;
          }
          ;
          if (key(e) === "x") {
            return Yank.value;
          }
          ;
          if (key(e) === "c") {
            return Copy.value;
          }
          ;
          if (key(e) === "v") {
            return Paste.value;
          }
          ;
          if (otherwise) {
            return new Unhandled(e);
          }
          ;
          throw new Error("Failed pattern match at Editor.Keyboard (line 90, column 13 - line 98, column 40): " + []);
        }();
        return k2;
      }
      ;
      if (key(e) === "backspace") {
        return Backspace.value;
      }
      ;
      if (key(e) === "Enter") {
        return Enter.value;
      }
      ;
      if (key(e) === "Tab" && isShift) {
        return ShiftTab.value;
      }
      ;
      if (key(e) === "Enter" && isShift) {
        return ShiftEnter.value;
      }
      ;
      if (code2(e) === "Space") {
        return SpaceKey.value;
      }
      ;
      if (key(e) === "ArrowLeft") {
        return Left2.value;
      }
      ;
      if (key(e) === "ArrowRight") {
        return Right2.value;
      }
      ;
      if (key(e) === "ArrowUp") {
        return Up.value;
      }
      ;
      if (key(e) === "ArrowDown") {
        return Down.value;
      }
      ;
      if (key(e) === "Shift") {
        return Shift.value;
      }
      ;
      if (key(e) === "Control") {
        return Control.value;
      }
      ;
      if (key(e) === "Alt") {
        return Alt2.value;
      }
      ;
      if (key(e) === "Tab") {
        return Tab.value;
      }
      ;
      if (key(e) === "Escape") {
        return Escape.value;
      }
      ;
      if (key(e) === "Enter") {
        return Enter.value;
      }
      ;
      if (key(e) === "PageUp") {
        return PageUp.value;
      }
      ;
      if (key(e) === "PageDown") {
        return PageDown.value;
      }
      ;
      if (key(e) === "Home") {
        return GoToStartOfLine.value;
      }
      ;
      if (key(e) === "End") {
        return GoToEndOfLine.value;
      }
      ;
      if (key(e) === "ArrowLeft" && isCtrl) {
        return GoToStartOfWord.value;
      }
      ;
      if (key(e) === "ArrowRight" && isCtrl) {
        return GoToEndOfWord.value;
      }
      ;
      if (key(e) === "") {
        return CapsLock.value;
      }
      ;
      if (key(e) === "Backspace") {
        return Backspace.value;
      }
      ;
      if (otherwise) {
        return new Unhandled(e);
      }
      ;
      throw new Error("Failed pattern match at Editor.Keyboard (line 87, column 5 - line 124, column 32): " + []);
    }();
    return k;
  };

  // output/Effect.Console/foreign.js
  var log2 = function(s2) {
    return function() {
      console.log(s2);
    };
  };

  // output/Effect.Class.Console/index.js
  var log3 = function(dictMonadEffect) {
    var $51 = liftEffect(dictMonadEffect);
    return function($52) {
      return $51(log2($52));
    };
  };

  // output/Editor/index.js
  var pureAttr2 = /* @__PURE__ */ pureAttr(attrPre_ClassString);
  var pureAttr1 = /* @__PURE__ */ pureAttr(attrPre_ContenteditableSt);
  var pureAttr22 = /* @__PURE__ */ pureAttr(attrOnAuxclickCb);
  var log4 = /* @__PURE__ */ log3(monadEffectEffect);
  var mapFlipped3 = /* @__PURE__ */ mapFlipped(functorEvent);
  var view2 = function(dict) {
    return dict.view;
  };
  var edit = function(dict) {
    return dict.edit;
  };
  var editor = function(dictEditable) {
    var edit1 = edit(dictEditable);
    var view1 = view2(dictEditable);
    return function(a2) {
      return bind4(useState(a2))(function(v) {
        return div_([pre([pureAttr2(Class.value)("editor"), pureAttr1(Contenteditable.value)("true"), pureAttr22(OnAuxclick.value)(cb(function(e) {
          return function __do2() {
            preventDefault(e)();
            return log4("TODO: Wire up context menu")();
          };
        })), keyDown(mapFlipped3(v.value1)(function(z) {
          return function(event) {
            return v.value0(edit1(keyAction(event))(z));
          };
        }))])([switcher(view1)(v.value1)])]);
      });
    };
  };

  // output/Zipper.String/index.js
  var pureAttr3 = /* @__PURE__ */ pureAttr(attrDiv_ClassString);
  var pureAttr12 = /* @__PURE__ */ pureAttr(attrDiv_IdString);
  var StringZipper = /* @__PURE__ */ function() {
    function StringZipper2(value0, value1) {
      this.value0 = value0;
      this.value1 = value1;
    }
    ;
    StringZipper2.create = function(value0) {
      return function(value1) {
        return new StringZipper2(value0, value1);
      };
    };
    return StringZipper2;
  }();
  var start2 = function(v) {
    return new StringZipper("", function($62) {
      return fromCharArray(reverse($62));
    }(toCharArray(v.value0)) + v.value1);
  };
  var snd2 = function(v) {
    return v.value1;
  };
  var right = function(v) {
    var v1 = uncons4(v.value1);
    if (v1 instanceof Nothing) {
      return new StringZipper(v.value0, v.value1);
    }
    ;
    if (v1 instanceof Just) {
      return new StringZipper(singleton8(v1.value0.head) + v.value0, v1.value0.tail);
    }
    ;
    throw new Error("Failed pattern match at Zipper.String (line 61, column 19 - line 63, column 56): " + [v1.constructor.name]);
  };
  var left = function(v) {
    var v1 = uncons4(v.value0);
    if (v1 instanceof Nothing) {
      return new StringZipper(v.value0, v.value1);
    }
    ;
    if (v1 instanceof Just) {
      return new StringZipper(v1.value0.tail, singleton8(v1.value0.head) + v.value1);
    }
    ;
    throw new Error("Failed pattern match at Zipper.String (line 56, column 18 - line 58, column 56): " + [v1.constructor.name]);
  };
  var insertString = function(s2) {
    return function(v) {
      return new StringZipper(s2 + v.value0, v.value1);
    };
  };
  var insert7 = function(s2) {
    return function(v) {
      return new StringZipper(singleton8(s2) + v.value0, v.value1);
    };
  };
  var fst2 = function(v) {
    return v.value0;
  };
  var end = function(v) {
    return new StringZipper(v.value0 + function($63) {
      return fromCharArray(reverse($63));
    }(toCharArray(v.value1)), "");
  };
  var backspace = function(v) {
    var v1 = uncons4(v.value0);
    if (v1 instanceof Nothing) {
      return new StringZipper(v.value0, v.value1);
    }
    ;
    if (v1 instanceof Just) {
      return new StringZipper(v1.value0.tail, v.value1);
    }
    ;
    throw new Error("Failed pattern match at Zipper.String (line 51, column 23 - line 53, column 36): " + [v1.constructor.name]);
  };
  var editableStringZipper = {
    view: function(zipper) {
      return div2([pureAttr3(Class.value)("zipper-view")])([text_(function($64) {
        return fromCharArray(reverse(toCharArray($64)));
      }(fst2(zipper))), div2([pureAttr12(Id.value)("fake-caret")])([]), text_(snd2(zipper))]);
    },
    edit: function(kevent) {
      if (kevent instanceof Enter) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof SpaceKey) {
        return insert7(codePointFromChar(" "));
      }
      ;
      if (kevent instanceof Left2) {
        return left;
      }
      ;
      if (kevent instanceof Right2) {
        return right;
      }
      ;
      if (kevent instanceof Up) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Down) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Shift) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Control) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Alt2) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Tab) {
        return insert7(codePointFromChar("	"));
      }
      ;
      if (kevent instanceof ShiftTab) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof CapsLock) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof ShiftEnter) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof PageUp) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof PageDown) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof GoToStartOfLine) {
        return start2;
      }
      ;
      if (kevent instanceof GoToEndOfLine) {
        return end;
      }
      ;
      if (kevent instanceof GoToStartOfWord) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof GoToEndOfWord) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Undo) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Redo) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof SelectAll) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Backspace) {
        return backspace;
      }
      ;
      if (kevent instanceof Copy) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Paste) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Save) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Yank) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Escape) {
        return function(x) {
          return x;
        };
      }
      ;
      if (kevent instanceof Unhandled) {
        var k = function() {
          if (key(kevent.value0) === "p" && ctrlKey(kevent.value0)) {
            return function(x) {
              return x;
            };
          }
          ;
          if (length6(key(kevent.value0)) > 1) {
            return function(x) {
              return x;
            };
          }
          ;
          if (otherwise) {
            return insertString(key(kevent.value0));
          }
          ;
          throw new Error("Failed pattern match at Zipper.String (line 108, column 11 - line 114, column 37): " + []);
        }();
        return k;
      }
      ;
      throw new Error("Failed pattern match at Zipper.String (line 75, column 5 - line 116, column 12): " + [kevent.constructor.name]);
    }
  };

  // output/Example.StringEditor.Main/index.js
  var main2 = /* @__PURE__ */ function() {
    return runInBody(div2([])([text_("Click below to start editing:"), editor(editableStringZipper)(new StringZipper(" olleH", "World!")), text_("You can use the arrow keys to move the cursor. Need to figure out how to properly style the caret."), h1_([text_("Bugs:")]), ul_([li_([text_("Enter to create newlines don't work")])])]));
  }();

  // <stdin>
  main2();
})();
