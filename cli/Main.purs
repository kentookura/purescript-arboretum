module Cli.Main where

import Prelude
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)
import Cli as Cli
import Node.Encoding (Encoding(..))
import Node.FS.Sync (exists, readTextFile, stat)
import Node.Path as Path
import Markup.Parser (parseMarkup)
import Watch (watch)

main :: Effect Unit
main = do
  let 
    path = "../../uni/BS_SS2023/lec9.md"
    fp = Path.concat
  mkup <- parseMarkup <$> readTextFile UTF8 path
  stats <- stat path
  watch path $ \c -> log $ show c
  log $ show mkup 
  log $ show stats