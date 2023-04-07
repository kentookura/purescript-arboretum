module Router.Chapter where

import Router.Route (Route(..))
import Pages.Overview (overview)
import Pages.Cryptography (cryptography)
import Prelude
import Contracts (Chapter)

routeToChapter :: forall lock payload. Route -> Chapter lock payload
routeToChapter Demo = overview
routeToChapter FourOhFour = overview
routeToChapter CryptographyIntro = cryptography
routeToChapter Notes = overview
routeToChapter Home = overview