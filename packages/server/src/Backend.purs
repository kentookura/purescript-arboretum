module Backend
  ( apiRouter
  , getDocument
  , getNamespace
  , htmlHeader
  , port
  ) where

import Prelude hiding ((/))

import API
import Affjax (Error(..))
import Data.Array as A
import Data.Either (Either(..))
import Data.Maybe
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (log)
import Fetch (fetch, Method(..))
import HTTPurple
import Node.FS.Aff (readFile)
import Node.FS.Sync (readTextFile)
import Node.Encoding (Encoding(..))
import Markup.Syntax (Markup)
import Markup.Parser (parseMarkup)
import Parsing (ParseError(..))
import HTTPurple.Json.Argonaut as Argonaut
import HTTPurple
import Fetch (fetch, Method(..))
import Affjax (Error(..))
import Data.Array as A
import Data.Either (Either(..), note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect.Aff (Aff)
import Effect.Class.Console (logShow, log)
import Markup.Parser (Doc, blockParser, BlockType)
import Parsing (ParseError(..), runParser)
import Markup.Namespace
import Markup.Parser (parseMarkup)
import Markup.Syntax (Markup)

port :: Int
port = 8080

htmlHeader = header "Content-Type" "text/html"

getNamespace :: String -> Maybe (Tree Listing)
getNamespace s
  | s == "algebra" = Just algebra
  | s == "analysis" = Just analysis
  | otherwise = Nothing

apiRouter :: forall r. { route :: Route | r } -> ResponseM
apiRouter { route: Home } = do
  body <- readFile "./webapp/index.html"
  ok' htmlHeader body

apiRouter { route: Src path } = do
  src <- readFile $ "./webapp/" <> path
  ok' (header "Content-Type" "text/javascript") src

apiRouter { route: Namespaces s } = do
  ok'
    ( headers
        { "Content-Type": "application/json"
        , "Access-Control-Allow-Origin": "*"
        , "Access-Control-Allow-Headers": "Content-Type"
        }
    ) $ toJson Argonaut.jsonEncoder $ getNamespace s

apiRouter { route: Docs ref } = do
  body <- readFile $ "./markdown/" <> ref <> ".md"
  ok' (headers 
        { "Content-Type" : "text/plain"
        , "Access-Control-Allow-Origin": "*"
        , "Access-Control-Allow-Headers": "Content-Type"
        }
  ) body

getDocument :: String -> Effect (Either Error Markup)
getDocument path = do
  res <- readTextFile UTF8 path
  case parseMarkup res of
    Right m -> pure $ Right m
    Left (ParseError s _) -> pure $ Left (RequestContentError s)
