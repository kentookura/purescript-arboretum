module Pages.Cryptography.Intro where

import Prelude
import Deku.Control (text_)
import Deku.DOM as D
import Router.Route (Route(..))
import Contracts (Page, page, Section, section, Subsection, subsection)

intro :: forall lock payload. Page lock payload
intro  = page
  {route: CryptographyIntro
  , topmatter: pure [ D.p_ [ text_ "This is an intro to cryptography"]]
  , sections: [ notes ]
  }

notes :: forall lock payload. Section lock payload
notes = section
  { title : "Notes"
  , topmatter : pure [text_ "asdf"]
  , subsections : [lecture1]
  }

lecture1 :: forall lock payload. Subsection lock payload
lecture1 = subsection
  { title : "subsection"
  , matter : pure [text_ "lecture 1"]
  }