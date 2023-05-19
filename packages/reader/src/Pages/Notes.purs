module Pages.Notes where

import Prelude

import Contracts (Page, page, section, subsection)
import Markup.Render (renderMarkup)
import Router.Route (Route(..))

--import Prism (forceHighlight)
--import QualifiedDo.Alt as Alt

notes :: Page
notes =
  page
    { route: Notes
    , topmatter: pure []
    , sections:
        [ section
            { title: ""
            , topmatter: pure
                [
                ]
            , subsections:
                [ subsection
                    { title: ""
                    , matter:
                        [ renderMarkup ""
                        ]
                    }
                ]
            }
        ]
    }
