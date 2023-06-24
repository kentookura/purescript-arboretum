module Route
  ( Route(..)
  , route
  ) where

import Prelude
import Data.Generic.Rep (class Generic)
import Routing.Duplex (print, parse, RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route = Workspace | FourOhFour | About | Revisions | Courses | Editor

derive instance Generic Route _
derive instance Eq Route
derive instance Ord Route

route :: RouteDuplex' Route
route = root $ sum
  { "Workspace": "workspace" / noArgs
  , "About": "about" / noArgs
  , "Revisions": "revisions" / noArgs
  , "Courses": "courses" / noArgs
  , "Editor": "editor" / noArgs
  , "FourOhFour": "404" / noArgs
  }