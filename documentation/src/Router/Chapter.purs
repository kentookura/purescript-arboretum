module Router.Chapter where

import Router.Route (Route(..))
import Pages.Introduction (introduction)
import Pages.Cryptography (cryptography)
import Prelude
import Contracts (Chapter)


routeToChapter :: forall lock payload. Route -> Chapter lock payload
routeToChapter Demo = introduction
routeToChapter FourOhFour = introduction
routeToChapter CryptographyIntro = cryptography
routeToChapter Notes = introduction
routeToChapter Home = introduction