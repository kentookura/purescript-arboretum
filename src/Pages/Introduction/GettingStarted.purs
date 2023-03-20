module Pages.Introduction.GettingStarted where


import Prelude

import Math (inline, display, editor)
import Katex (defaultOptions)

import Contracts (Page, page)
import Components.Code (psCode)
import Data.Foldable (oneOf)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Pages.Zipper (zipper)
--import Pages.Introduction.GettingStarted.GettingHelp (gettingHelp)
--import Pages.Introduction.GettingStarted.QuickStart (quickStart)
--import Pages.Introduction.GettingStarted.WhyDeku (whyDeku)
import Router.ADT (Route(..))
import Prism (forceHighlight)

gettingStarted :: forall lock payload. Page lock payload
gettingStarted = page
  { route: GettingStarted
  , topmatter: pure
      [ D.p_
          [ text_
              "Here I experiment with mathematical markup and rich documents. I can write mathematics here, both inline expressions such as "
          , inline "a \\otimes b" defaultOptions
          , text_ " and as a block:"
          , display "\\int_0^{\\infty}f(x) dx." defaultOptions
          , D.pre 
              ( oneOf 
                  [ D.Style !:= "background:none;padding:0em;margin:0em;"
                  , D.Class !:= "prism-code language-purescript flex overflow-x-auto pb-6"
                  ]
              )
            [ D.code
                ( oneOf
                  [ D.Class !:= "px-4 rounded"
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
  ]
  , sections: []
      --[ quickStart, {-basicUsage,-} whyDeku, gettingHelp ]
  }