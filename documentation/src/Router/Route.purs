module Router.Route
  ( Route(..)
  , routeToTitle
  , route
  ) where

import Prelude hiding ((/))

import Data.Array (zip, drop)
import Data.Maybe (Maybe(..))
import Data.Map (Map, fromFoldable, lookup)
import Data.Newtype (unwrap)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Demo
  | Home
  | FourOhFour
  | Notes
  | CryptographyIntro

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
  , "Notes": "notes" / noArgs
  , "FourOhFour": "404" / noArgs
  }
