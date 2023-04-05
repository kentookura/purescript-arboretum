module Pages.Notes where

import Prelude

import Math (inline, display, editor, differentialEqn, typeahead, definedIn)
import Pages.Demos (demos)
import Katex (defaultOptions)
import Contracts (Page, page, Section, section, Subsection, subsection)
import Deku.DOM as D
import Deku.Control (text_)
--import Components.Code (psCode)
--import Data.Foldable (oneOf)
--import Deku.Attribute ((!:=))
--import Deku.Attributes (href_, klass_)
--import Deku.Control (text_)
--import Deku.DOM as D
--import Pages.Zipper (zipper)
import Router.Route (Route(..))
--import Prism (forceHighlight)
--import QualifiedDo.Alt as Alt

notes :: forall lock payload. Page lock payload
notes =
  page
    { route: Notes
    , topmatter: pure []
    , sections:
        [ section
            { title: "Notes"
            , topmatter: pure []
            , subsections: [
                subsection {
                  title: "TODOS",
                  matter: [
                    D.ul_ [
                      D.li_ [
                        text_ "Differentiate terms: ",
                        inline defaultOptions "(f+g)' = f' + g'",
                        text_ " automatically. There is maybe some literature on doing something like this on the type level."
                        ]
                    ]
                  ]
                }
              ]
            }
        ]
    }
