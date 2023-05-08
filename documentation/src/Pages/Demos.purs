module Pages.Demos
  ( demos
  ) where

import Prelude

import Contracts (Page, page, section, subsection)
import Data.Array (reverse)
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Deku.Attribute ((!:=))
import Deku.Attributes (href_)
import Deku.Control (text_, blank)
import Deku.DOM as D
import Markup.Contracts (Theorem, theorem)
import Markup.Examples (raw)
import Markup.Editor (editor)
import Markup.Katex (defaultOptions)
import Markup.Math (inline, display)
import Markup.Penrose (viewSources)
import Markup.Penrose as Penrose
import Markup.Render (renderMarkup)
import Prism (forceHighlight)
import QualifiedDo.Alt as Alt
import Router.Route (Route(..))
import Notes (helloMarkdown)
import Zipper.String ((-|-))

demos :: Page
demos =
  page
    { route: Demo
    , topmatter: pure []
    , sections:
        [ section
            { title: ""
            , topmatter: pure $
                [ renderMarkup
                    """
This app is based on the [Deku documentation](https://github.com/mikesol/deku-documentation). I hooked up a [markdown parser](https://github.com/kentookura/purescript-markdown) to the page and we have a basic static site generator!. I am currently not handling linking between pages.  For that I need to take a closer look at how links are parsed. 
"""
                ]
            , subsections:
                [ subsection
                    { title: "Mathematical Markup"
                    , matter:
                        [ renderMarkup """$\KaTeX$ support: $a  \otimes b$. Parsing double dollar signs is still a todo, but you can call the FFI:"""
                        , display defaultOptions "\\int_0^{\\infty}f(x) dx."
                        ]
                    }
                , subsection
                    { title: "Penrose FFI"
                    , matter:
                        [ renderMarkup
                            """
I set up a basic FFI for [Penrose](https://penrose.cs.cmu.edu)
                        """
                        , Penrose.render Penrose.examples.program
                        , viewSources Penrose.examples.program
                        ]
                    }
                , subsection
                    { title: "Markdown Support"
                    , matter:
                        [ renderMarkup helloMarkdown
                        ]
                    }
                , subsection
                    { title: "Editor component"
                    , matter:
                        [ editor ((fromCharArray <<< reverse <<< toCharArray) "Control the position of the caret: " -|- " by using the arrow keys")
                        ]
                    }
                ]
            }
        ]
    }