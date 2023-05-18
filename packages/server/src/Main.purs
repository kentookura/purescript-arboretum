module Server.Main where

import HTTPurple
import Backend

main :: ServerM
main = serve { port: port } { route: api, router: apiRouter }