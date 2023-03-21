module Pages.Demos
  ( demos
  ) where

import Prelude
import Math (inline, display, editor, differentialEqn, typeahead, definedIn)
import Katex (defaultOptions)
import Contracts (Page, page, Section, section, Subsection, subsection)
import Components.Code (psCode)
import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (href_, klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Pages.Zipper (zipper)
import Router.Route (Route(..))
import Prism (forceHighlight)
import QualifiedDo.Alt as Alt

demos :: forall lock payload. Page lock payload
demos =
  page
    { route: Demo
    , topmatter: pure []
    , sections:
        [ section
            { title: ""
            , topmatter:
                pure
                  [ text_ "Here I experiment with mathematical markup and rich documents. I can write mathematics here, both inline expressions such as "
                  , inline defaultOptions "a \\otimes b"
                  , text_ " and as a block:"
                  , display defaultOptions "\\int_0^{\\infty}f(x) dx."
                  , text_ "You can also display code, which gets nicely highlighted by the"
                  , D.a Alt.do
                      href_ "https://prismjs.com"
                      D.Target !:= "_blank"
                    [ text_ " Prism " ]
                  , text_ "library."
                  , D.pre
                      ( oneOf
                          [ D.Style !:= "background:none;padding:0em;margin:0em;"
                          , D.Class !:= "prism-code language-purescript flex overflow-x-auto pb-6"
                          ]
                      )
                      [ D.code
                          ( oneOf
                              [ D.Class !:= "m-4 py-4 rounded"
                              ]
                          )
                          [ text_
                              """myButton :: Nut
  myButton =
    D.button
      (buttonStyle <|> confettiClick)
      [text_ "Click me" ]
                          """
                          ]
                      ]
                  , forceHighlight
                  ]
            , subsections:
                [ subsection
                    { title: "About"
                    , matter:
                        pure
                          []
                    }
                ]
            }
        ]
    --, id: "sasdlfkja;sdlkfj"
    }

--            -- , editor
-- , differentialEqn
-- , typeahead
