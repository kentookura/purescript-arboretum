module Markup.Examples
  ( raw
  , theorems
  ) where

import Prelude

import Markup.Contracts (theorem, Theorem)
import Deku.Control (blank)

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
    , statement: blank
    , proof: blank
    }

comparisonPrinciple :: Theorem
comparisonPrinciple =
  theorem
    { title: "Comparison Principle for Caloric Functions on bounded sets"
    , statement: blank
    , proof: blank
    }

meanValueHarmonic :: Theorem
meanValueHarmonic =
  theorem
    { title: "The MVP for harmonic functions"
    , statement: blank
    , proof: blank
    }

raw =
  """# Foobar

Foobar is a Python library for dealing with word pluralization.

## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

```bash
pip install foobar
```

## Usage

```python
import foobar

# returns 'words'
foobar.pluralize('word')

# returns 'geese'
foobar.pluralize('goose')

# returns 'phenomenon'
foobar.singularize('phenomena')
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)



      """
