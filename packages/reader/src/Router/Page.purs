module Router.Page where

import Prelude

import Contracts (Page)
import Pages.FourOhFour (fourOhFour)
import Pages.Demos (demos)
import Pages.Notes (notes)
import Pages.Cryptography.Intro (intro)
import Router.Route (Route(..))

routeToPage :: Route -> Page
routeToPage Demo = demos
routeToPage Home = demos
routeToPage Notes = notes
routeToPage FourOhFour = fourOhFour
routeToPage CryptographyIntro = intro