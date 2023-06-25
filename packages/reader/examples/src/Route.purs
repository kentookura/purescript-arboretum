module MyBook
  ( myBook
  ) where

import Prelude hiding ((/))
import Deku.Control (text_)
import Deku.DOM as D
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))
import Contracts (class Routed, Book(..), Page, Chapter, Section, Subsection(..), page, chapter, section, subsection)
import Text.Markdown.SlamDown.Render (renderMdFromString)
import Pages.FourOhFour (fourOhFour)
import Katex as Katex
import Effect (Effect)
import Main

myBook :: Effect Unit
myBook = main route book

data Route
  = Demo
  | Home
  | FourOhFour
  | Notes
  | CryptographyIntro

instance Routed Page Route where
  fromRoute Demo = demos
  fromRoute Home = demos
  fromRoute Notes = notes
  fromRoute FourOhFour = fourOhFour FourOhFour Home
  fromRoute CryptographyIntro = intro

instance Routed Chapter Route where
  fromRoute Demo = overview
  fromRoute FourOhFour = overview
  fromRoute CryptographyIntro = cryptography
  fromRoute Notes = overview
  fromRoute Home = overview

derive instance Generic Route _
derive instance Eq Route
derive instance Ord Route

instance Show Route where
  show = genericShow

routeToTitle :: Route -> String
routeToTitle Home = "Home"
routeToTitle Demo = "Demos"
routeToTitle FourOhFour = "The Diamond Club Penthouse"
routeToTitle Notes = "Notebook"
routeToTitle CryptographyIntro = "Introduction to Cryptography"

route :: RouteDuplex' Route
route = root $ sum
  { "Home": noArgs
  , "Demo": "demo" / noArgs
  , "CryptographyIntro": "cryptography" / "intro" / noArgs
  , "Notes": "overview" / "notebook" / noArgs
  , "FourOhFour": "404" / noArgs
  }

book :: Book Route
book = Book [ overview, cryptography ]

overview :: Chapter Route
overview = chapter
  { title: "Overview", pages: [ demos, notes ] }

cryptography :: Chapter Route
cryptography = chapter
  { title: "Cryptography", pages: [ intro ] }

intro :: Page Route
intro = 
  (const "Intro") #
  page
    { route: CryptographyIntro
    , topmatter: pure [ D.p_ [ text_ "This is an intro to cryptography" ] ]
    , sections: [ ]
    }

notes :: Page Route
notes = 
  (const "Notes") #
  page
    { route: Notes
    , topmatter: pure [ text_ "asdf" ]
    , sections: [ ]
    }

demos :: Page Route
demos =
  (const "Demos") #
  page
    { route: Demo
    , topmatter: pure []
    , sections:
        [ section
            { title: ""
            , topmatter: pure $
                [ renderMdFromString
                    """
This app is based on the [Deku documentation](https://github.com/mikesol/deku-documentation). I hooked up a [markdown parser](https://github.com/kentookura/purescript-markdown) to the page and we have a basic static site generator!. I am currently not handling linking between pages.  For that I need to take a closer look at how links are parsed. 
"""
                ]
            , subsections:
                [ subsection
                    { title: "Mathematical Markup"
                    , matter:
                        [ renderMdFromString """$\KaTeX$ support: $a  \otimes b$. Parsing double dollar signs is still a todo, but you can call the FFI:"""
                        , Katex.inline "\\int_0^{\\infty}f(x) dx."
                        ]
                    }
                , subsection
                    { title: "Penrose FFI"
                    , matter:
                        [ renderMdFromString
                            """
I set up a basic FFI for [Penrose](https://penrose.cs.cmu.edu)
                        """
                        --, Penrose.render Penrose.examples.program
                        --, viewSources Penrose.examples.program
                        ]
                    }
                --, subsection
                --    { title: "Markdown Support"
                --    , matter:
                --        [ renderMdFromString helloMarkdown
                --        ]
                --    }
                --, subsection
                --    { title: "Editor component"
                --    , matter:
                --        [ editor ((fromCharArray <<< reverse <<< toCharArray) "Control the position of the caret: " -|- " by using the arrow keys")
                --        ]
                --    }
                ]
            }
        ]
    }