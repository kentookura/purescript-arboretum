module Markup.Examples
  ( raw
  , theorems
  ) where

import Markup.Contracts (theorem, Theorem)
import Markup.Render (renderMarkup)
import Deku.Control (blank)

theorems :: Array Theorem
theorems =
  [ cauchyProblem
  , dAlembertFormula
  , liouville
  , comparisonPrinciple
  , meanValueHarmonic
  ]

cauchyProblem :: Theorem
cauchyProblem =
  theorem
    { title: "The Cauchy Problem of the n-dimensional Heat Equation"
    , statement: blank
    , proof: blank
    }

dAlembertFormula :: Theorem
dAlembertFormula =
  theorem
    { title: "The D'Alembert Formula for the one dimensional Wave Equation"
    , statement: blank
    , proof: blank
    }

liouville :: Theorem
liouville =
  theorem
    { title: "Liouville's Theorem"
    , statement: renderMarkup
        """
Let $u: \R^n \to \R$ be harmonic and bounded. Then $u$ is constant.
"""
    , proof: renderMarkup
        """
We know that $u \in C^\infty(\R^n)$ since harmonic functions are smooth.  Consider the $i$-th partial derivative $u_{x_i}$. We have $\Delta u_{x_i} = \partial_{x_i} \Delta u = 0$, so $u_{x_i}$ is harmonic.  Furthermore

$$
  |u_{x_i}| = 
$$

"""
    }

comparisonPrinciple :: Theorem
comparisonPrinciple =
  theorem
    { title: "Comparison Principle for Caloric Functions on bounded sets"
    , statement: renderMarkup
        """
Let $\Omega \subset \R^n$ open and bounded. Let $0 < T < +\infty$ and $u, v \in C(\overline{\Omega}_T)$ caloric. Furthermore let $u \le v$ on $\partial_p \Omega_T$. Then $u \le v$ on $\overline{\Omega_T}$.
"""
    , proof: renderMarkup
        """
"""
    }

meanValueHarmonic :: Theorem
meanValueHarmonic =
  theorem
    { title: "The MVP for harmonic functions"
    , statement: blank
    , proof: blank
    }

raw :: String
raw =
  """
# T
  """
