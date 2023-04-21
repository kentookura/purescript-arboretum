module Contracts where

import Prelude
import Data.Array (intercalate)
import Data.Newtype (class Newtype)
import Data.String (Pattern(..), split, toLower)
import Record (union)
import Router.Route (Route, routeToTitle)
import Deku.Core (Nut)

newtype Env = Env
  { routeLink :: Route -> Nut
  , routeLinkWithText :: Route -> String -> Nut
  }

newtype Page = Page
  { path :: String
  , title :: String
  , route :: Route
  , topmatter :: Env -> Array Nut
  , sections :: Array Section
  }

derive instance Newtype Page _

page
  :: { route :: Route
     , topmatter :: Env -> Array Nut
     , sections :: Array Section
     }
  -> Page
page i = Page
  ( i `union`
      { title
      , path: "/" <>
          (intercalate "-" $ map toLower $ split (Pattern " ") title)
      }
  )
  where
  title = routeToTitle i.route

newtype Section = Section
  { title :: String
  , id :: String
  , topmatter :: Env -> Array Nut
  , subsections :: Array Subsection
  }

newtype Book = Book (Array Chapter)

derive instance Newtype Book _
newtype Chapter = Chapter
  { title :: String, path :: String, pages :: Array (Page) }

derive instance Newtype Chapter _

chapter
  :: { title :: String
     , pages :: Array (Page)
     }
  -> Chapter
chapter i = Chapter
  ( i `union`
      { path: "/" <>
          (intercalate "-" $ map toLower $ split (Pattern " ") i.title)
      }
  )

section
  :: { title :: String
     , topmatter :: Env -> Array Nut
     , subsections :: Array Subsection
     }
  -> Section
section i = Section
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )

newtype Subsection = Subsection
  { title :: String
  , id :: String
  , matter :: Array (Nut)
  }

subsection
  :: { title :: String
     , matter :: Array Nut
     }
  -> Subsection
subsection i = Subsection
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )