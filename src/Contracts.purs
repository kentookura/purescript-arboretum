module Contracts where

import Prelude

import Data.Array (intercalate)
import Data.Newtype (class Newtype)
import Data.String (Pattern(..), split, toLower)
import Deku.Core (Domable)
import Record (union)
import Router.Route (Route, routeToTitle)

newtype Env = Env
  { routeLink :: forall lock payload. Route -> Domable lock payload
  , routeLinkWithText ::
      forall lock payload. Route -> String -> Domable lock payload
  }

newtype Docs lock paylaod = Docs (Array (Chapter lock paylaod))

derive instance Newtype (Docs lock paylaod) _
newtype Chapter lock payload = Chapter
  { title :: String, path :: String, pages :: Array (Page lock payload) }

derive instance Newtype (Chapter lock paylaod) _

chapter
  :: forall lock payload
   . { title :: String
     , pages :: Array (Page lock payload)
     }
  -> Chapter lock payload
chapter i = Chapter
  ( i `union`
      { path: "/" <>
          (intercalate "-" $ map toLower $ split (Pattern " ") i.title)
      }
  )

newtype Page lock payload = Page
  { path :: String
  , title :: String
  , route :: Route
  , topmatter :: Env -> Array (Domable lock payload)
  , sections :: Array (Section lock payload)
  }

derive instance Newtype (Page lock payload) _

page
  :: forall lock payload
   . { route :: Route
     , topmatter :: Env -> Array (Domable lock payload)
     , sections :: Array (Section lock payload)
     }
  -> Page lock payload
page i = Page
  ( i `union`
      { title
      , path: "/" <>
          (intercalate "-" $ map toLower $ split (Pattern " ") title)
      }
  )
  where
  title = routeToTitle i.route

newtype Section lock payload = Section
  { title :: String
  , id :: String
  , topmatter :: Env -> Array (Domable lock payload)
  , subsections :: Array (Subsection lock payload)
  }

section
  :: forall lock payload
   . { title :: String
     , topmatter :: Env -> Array (Domable lock payload)
     , subsections :: Array (Subsection lock payload)
     }
  -> Section lock payload
section i = Section
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )

newtype Subsection lock payload = Subsection
  { title :: String
  , id :: String
  , matter :: Env -> Array (Domable lock payload)
  }

subsection
  :: forall lock payload
   . { title :: String
     , matter :: Env -> Array (Domable lock payload)
     }
  -> Subsection lock payload
subsection i = Subsection
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )