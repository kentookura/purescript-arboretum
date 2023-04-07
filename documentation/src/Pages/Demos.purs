module Pages.Demos
  ( demos
  ) where

import Prelude
import Contracts (Page, page, Section, section, Subsection, subsection)
import Components.Code (psCode)
import Components.Terminal (repl)
import Data.Foldable (oneOf)
import Data.List (List(..))
import Deku.Attribute ((!:=))
import Deku.Attributes (href_, klass_)
import Deku.Control (text_, blank)
import Deku.Core (Nut)
import Deku.DOM as D
import Pages.Zipper (zipper)
import Router.Route (Route(..))
import Prism (forceHighlight)
import QualifiedDo.Alt as Alt
import Markup.Penrose (penroseExample, viewSources, myProgram)
import Markup.Editor (editor)
import Markup.Contracts (theorem)
import Markup.Katex (defaultOptions)
import Markup.Math (inline, display, differentialEqn, typeahead, definedIn)
import Markup.Parser (parseMarkup)
import Markup.Render (renderMarkup, renderTheorem)
import Markup.Syntax (Markup(..))

demos :: forall lock payload. Page lock payload
demos =
  page
    { route: Demo
    , topmatter: pure []
    , sections:
        [ section
            { title: "Demos"
            , topmatter:
                pure
                  [ text_ "Below are demonstrations of the current capabilities."
                  ]
            , subsections:
                [ subsection
                    { title: "Mathematical Markup"
                    , matter:
                        [ text_ "I can write mathematics here, both inline expressions such as "
                        , inline defaultOptions "a \\otimes b"
                        , text_ " and in display mode:"
                        , display defaultOptions "\\int_0^{\\infty}f(x) dx."
                        ]
                    }
                , subsection
                    { title: "Code Highlighting"
                    , matter:
                        [ text_ "Syntax highlighting is done by the "
                        , D.a
                            Alt.do
                              href_ "https://prismjs.com"
                              D.Target !:= "_blank"
                            [ text_ " Prism " ]
                        , text_ "library. "
                        , forceHighlight
                        ]
                    }
                , subsection
                    { title: "Penrose Diagrams"
                    , matter:
                        [ text_ "We can generate diagrams using "
                        , D.a
                            Alt.do
                              href_ "https://penrose.cs.cmu.edu"
                              D.Target !:= "_blank"
                            [ text_ " Penrose " ]
                        , text_ ". Currently disabled due to performance reasons."
                        --, penroseExample
                        --, viewSources myProgram
                        ]
                    }
                , subsection
                    { title: "Markdown Support"
                    , matter:
                        [ renderMarkup markdownDoc
                        ]
                    }
                , subsection
                    { title: "Editor component"
                    , matter:
                        [ editor
                        ]
                    }
                , subsection
                    { title: "Rendering theorems"
                    , matter: []
                    --renderTheorem <$>
                    --  [ cauchyProblem
                    --  , dAlembertFormula
                    --  , liouville
                    --  , comparisonPrinciple
                    --  , meanValueHarmonic
                    --  ]
                    }
                ]
            }
        ]
    }

markdownDoc =
  """This part of the document is parsed. The markup format currently supports headings, lists:

An unordered list:

* Item 1
* Item 2

```{purescript}
foreign import asdf asdf
```

"""

cauchyProblem =
  theorem
    { title: "The Cauchy Problem of the n-dimensional Heat Equation"
    , statement: blank
    , proof: blank
    }

dAlembertFormula =
  theorem
    { title: "The D'Alembert Formula for the one dimensional Wave Equation"
    , statement: blank
    , proof: blank
    }

liouville =
  theorem
    { title: "Liouville's Theorem"
    , statement: blank
    , proof: blank
    }

comparisonPrinciple =
  theorem
    { title: "Comparison Principle for Caloric Functions on bounded sets"
    , statement: blank
    , proof: blank
    }

meanValueHarmonic =
  theorem
    { title: "The MVP for harmonic functions"
    , statement: blank
    , proof: blank
    }