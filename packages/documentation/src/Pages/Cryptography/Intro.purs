module Pages.Cryptography.Intro where

import Prelude
import Deku.Control (text_)
import Deku.DOM as D
import Router.Route (Route(..))
import Contracts (Page, page, Section, section, Subsection, subsection)

intro :: Page
intro = page
  { route: CryptographyIntro
  , topmatter: pure [ D.p_ [ text_ "This is an intro to cryptography" ] ]
  , sections: [ notes ]
  }

notes :: Section
notes = section
  { title: "Notes"
  , topmatter: pure [ text_ "asdf" ]
  , subsections: [ lecture1 ]
  }

lecture1 :: Subsection
lecture1 = subsection
  { title: "Lecture 1"
  , matter: [ text_ "lecture 1" ]
  }

lecture2 :: Subsection
lecture2 = subsection
  { title: "28.03.2023"
  , matter: [ text_ "" ]
  }

