module Markup.Namespace where

import Prelude

import Data.Array (replicate)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Console (log)
import Effect.Class.Console (logShow)
import Data.Argonaut.Encode.Generic
import Data.Argonaut.Encode
import Data.Argonaut.Decode.Generic
import Data.Argonaut.Decode

data Tree a
  = Namespace String (Array (Tree a))
  | Node a

data Listing = Theorem String | Markup String | Definition String

instance showListing :: Show Listing where
  show (Theorem s) = s
  show (Markup s) = s
  show (Definition s) = s

instance Show (Tree Listing) where
  show tree = genericShow tree

derive instance genericListing :: Generic Listing _

derive instance genericTree :: Generic (Tree Listing) _

instance encodeJsonListing :: EncodeJson Listing where
  encodeJson listing = genericEncodeJson listing

instance decodeJsonListing :: DecodeJson Listing where
  decodeJson listing = genericDecodeJson listing

instance encodeJsonTree :: EncodeJson (Tree Listing) where
  encodeJson tree = genericEncodeJson tree

instance decodeJsonTree :: DecodeJson (Tree Listing) where
  decodeJson tree = genericDecodeJson tree


algebra :: Tree Listing
algebra = Namespace "Algebra"
  [ Namespace "Groups"
      [ Node (Definition "Group")
      ]
  , Namespace "Rings"
      [ Node (Definition "Ring")
      ]
  , Namespace "Fields"
      [ Node (Definition "Field")
      ]
  ]

analysis :: Tree Listing
analysis =
  Namespace "Analysis"
    [ Node (Theorem "The fundamental theorem of calculus")
    , Namespace "Complex"
        [ Node (Theorem "The Cauchy Integral formula")
        , Node (Markup "Notes")
        ]
    ]
