module Cli.Main
  ( main
  )
  where

import Prelude
import Affjax (Error(..))
import Data.Array as A
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (logShow, log)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Options (optionsParser)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readTextFile)
import Markup.Parser (Doc, blockParser, BlockType)
import Parsing (ParseError(..), runParser)



getDocument :: String -> Effect (Either Error (Doc BlockType))
getDocument path = do
  res <- readTextFile UTF8 path
  case runParser res blockParser of
    Right m -> pure $ Right m
    Left (ParseError s _) -> pure $ Left (RequestContentError s)



main :: Effect Unit
main = launchAff_ do
  config@{ port, outputDirectory, sourceDirectories } <- liftEffect optionsParser
  logShow config
  liftEffect do
    watchDirectories

--watchDirectories :: ?T
watchDirectories :: Array String -> (String -> Array String) -> Effect Unit
watchDirectories directories glob = 
    (runEffectFn2 gazeImpl)
      (A.concatMap glob directories)
      (\(d :: String) -> do
        docs <- getDocument d
        log d
        case docs of 
          Left l -> pure unit
          Right r -> logShow r
      ) 


fileGlob :: String -> Array String
fileGlob dir = 
  let go x = dir <> "/**/*" <> x
<<<<<<< HEAD
  in go <$> [".md", ".neat"]
=======
  in go <$> [".md"]
>>>>>>> 1379100 (watch files a la psc-ide)

foreign import gazeImpl :: EffectFn2 (Array String) (String -> Effect Unit) Unit