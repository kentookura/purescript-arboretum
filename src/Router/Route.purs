module Router.Route
  ( Route(..)
  , routeToTitle
  , route
  )
  where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route
  = Demo
  | Home
  | FourOhFour
  | HelloWorld
  | CryptographyIntro

derive instance Generic Route _
derive instance Eq Route
derive instance Ord Route

instance Show Route where
  show = genericShow

routeToTitle :: Route -> String
routeToTitle Demo = "Structured Editing for Mathematical Markup"
routeToTitle Home = "Home"
routeToTitle FourOhFour = "The Diamond Club Penthouse"
routeToTitle CryptographyIntro = "Introduction to Cryptography"
routeToTitle HelloWorld = "HelloWorld"

route :: RouteDuplex' Route
route = root $ sum
  { "Home" : noArgs
  , "Demo": "demo" / noArgs
  , "HelloWorld": "introduction" / "hello-world" / noArgs
  , "CryptographyIntro" : "cryptography" / "intro"/ noArgs
  , "FourOhFour": "404" / noArgs
  --, "Components": "core-concepts" / "components" / noArgs
  --, "State": "core-concepts" / "state" / noArgs
  --, "Pursx": "core-concepts" / "pursx" / noArgs
  --, "Collections": "core-concepts" / "collections" / noArgs
  --, "Portals": "core-concepts" / "portals" / noArgs
  --, "Providers": "core-concepts" / "providers" / noArgs
  --, "Effects": "core-concepts" / "effects" / noArgs
  --, "MoreHooks": "core-concepts" / "more-hooks" / noArgs
  --, "Events": "functional-reactive-programming" / "events" / noArgs
  --, "Applicatives": "functional-reactive-programming" / "applicatives" / noArgs
  --, "Alternatives": "functional-reactive-programming" / "alternatives" / noArgs
  --, "Filtering": "functional-reactive-programming" / "filtering" / noArgs
  --, "Sampling": "functional-reactive-programming" / "sampling" / noArgs
  --, "OtherInstances": "functional-reactive-programming" / "other-instances" /
      --noArgs
  --, "Busses": "functional-reactive-programming" / "busses" / noArgs
  --, "FixAndFold": "functional-reactive-programming" / "fix-and-fold" / noArgs
  --, "Behaviors": "functional-reactive-programming" / "behaviors" / noArgs
  --, "CustomElements": "advanced-usage" / "custom-elements" / noArgs
  --, "AccessingTheDOM": "advanced-usage" / "accessing-the-dom" / noArgs
  --, "SSR": "advanced-usage" / "ssr" / noArgs
  }