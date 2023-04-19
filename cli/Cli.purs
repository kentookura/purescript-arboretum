module Cli
  ( Sample(..)
  , greet
  , sample
  , main
  )
  where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Data.Foldable (sequence_)

import Data.Array (replicate)
import Options.Applicative
import Data.Semigroup ((<>))

data Sample = 
  Sample 
  { hello :: String
  , quiet :: Boolean
  , enthusiasm :: Int
  }

sample :: Parser Sample
sample = map Sample $ ({ hello:_, quiet:_, enthusiasm:_})
  <$> strOption 
    ( long "hello"
    <> metavar "TARGET"
    <> help "Target for the greeting"
    )

  <*> switch
    ( long "quiet"
    <> short 'q'
    <> help "Wheter to be quiet"
    )

  <*> option int 
    ( long "enthusiasm"
    <> help "How enthusiastically to greet"
    <> showDefault
    <> value 1
    <> metavar "INT"
    )

main :: Effect Unit
main = do
  
  greet =<< execParser opts
  where
    opts = info (sample <**> helper)
      (fullDesc
      <> progDesc "Print a greeting for TARGET"
      <> header "hello - a test for purescript-optparse")

greet :: Sample -> Effect Unit   
greet (Sample {hello, quiet: false, enthusiasm}) = sequence_ $ replicate enthusiasm $ log $ "Hello, " <> hello
greet _ = pure unit