module Main
  ( main
  )
  where

import Prelude

import API (api, Route(..), port)

import Control.Monad.Reader
import Data.Either (Either)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (logShow)
import Fetch (Method(..), fetch)
import Routing.Duplex (print)
import Fetch.Argonaut.Json (fromJson)
import Markup.Namespace (Tree, Listing)
import Markup.Parser (parseMarkup)
import Markup.Syntax (Markup)
import Parsing (ParseError)

apiURL :: String
apiURL = "http://127.0.0.1"

jsonHeaders = { "Content-Type": "application/json"}

get :: Route -> Aff _
get route = do
  fetch (apiURL <> ":" <>  show port <> (print api $ route)) 
    { method: GET
    , headers: jsonHeaders
    } 
  
get_ :: Route -> Aff (Either ParseError Markup)
get_ route = do
  { text } <- fetch (apiURL <> ":" <>  show port <> (print api $ route)) 
    { method: GET
    , headers: jsonHeaders
    } 
  content <- text
  pure $ parseMarkup content

main :: Effect Unit
main = launchAff_ do
  { json } <- get $ Namespace "analysis"
  namespace :: Tree Listing <- fromJson json 
  markdown  <- get_ $ Doc "index"
  logShow namespace
  logShow markdown
