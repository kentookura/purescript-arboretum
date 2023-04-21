module Pages.Demos
  ( demos
  ) where

import Prelude

import Contracts (Page, page, section, subsection)
import Deku.Attribute ((!:=))
import Deku.Attributes (href_)
import Deku.Control (text_, blank)
import Deku.DOM as D
import Markup.Contracts (Theorem, theorem)
import Markup.Examples (raw)
import Markup.Katex (defaultOptions)
import Markup.Math (inline, display)
import Markup.Render (renderMarkup)
import Prism (forceHighlight)
import QualifiedDo.Alt as Alt
import Router.Route (Route(..))

demos :: Page
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
                            [ href_ "https://prismjs.com"
                            , D.Target !:= "_blank"
                            ]
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
                            [ href_ "https://penrose.cs.cmu.edu"
                            , D.Target !:= "_blank"
                            ]
                            [ text_ " Penrose " ]
                        , text_ ". Currently disabled due to performance reasons."
                        --, penroseExample
                        --, viewSources myProgram
                        ]
                    }
                , subsection
                    { title: "Markdown Support"
                    , matter:
                        [ renderMarkup raw
                        ]
                    }
                --, subsection
                --    { title: "Editor component"
                --    , matter:
                --        [ editor
                --        ]
                --    }
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
