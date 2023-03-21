module Router.Page where

import Prelude

import Contracts (Page)
import Pages.FourOhFour (fourOhFour)
import Pages.Demos (demos)
import Pages.Introduction.HelloWorld (helloWorld)
import Pages.Cryptography.Intro (intro)
import Router.Route (Route(..))

routeToPage :: forall lock payload. Route -> Page lock payload
routeToPage Demo = demos
routeToPage Home = demos
routeToPage FourOhFour = fourOhFour
routeToPage HelloWorld = helloWorld
routeToPage CryptographyIntro = intro