module API.Requests where

import Prelude
import Affjax (get, printError)
import Affjax.ResponseFormat (string)
import Affjax.Web (driver)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import Markup.Parser (parseMarkup)


getMarkup :: Effect Unit
getMarkup = launchAff_ $ do
  result <- get driver string "/examples/hello.md"
  case result of
    Left err -> do
      log $ "GET /examples/hello.md failed: " <> printError err
    Right result -> do
      case parseMarkup result.body of
        Right m -> do
          log $ "Parser Succeeded" <> show m
        Left e -> do
          log $ "Parser failed: " <> show e