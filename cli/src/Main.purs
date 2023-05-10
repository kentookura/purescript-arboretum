module Main
  ( main
  )
  where

import Prelude
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import HTTPurple (serve)
import API (api, apiRouter)
import API.Options (optionsParser)


main :: Effect Unit
main = do
  config@{ port, outputDirectory, sourceDirectories } <- liftEffect optionsParser
  shutdown <- serve { port } { route: api, router: apiRouter}
  do pure unit
