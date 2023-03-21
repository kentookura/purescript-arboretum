module Router.Chapter where

import Prelude

import Contracts (Chapter)
import Pages.Introduction (introduction)
import Pages.Cryptography (cryptography)
import Router.Route (Route(..))

routeToChapter :: forall lock payload. Route -> Chapter lock payload
routeToChapter Demo = introduction
routeToChapter HelloWorld = introduction
routeToChapter FourOhFour = introduction
routeToChapter CryptographyIntro = cryptography
routeToChapter Home = introduction
