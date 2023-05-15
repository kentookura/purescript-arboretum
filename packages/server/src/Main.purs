module Server.Main where

import HTTPurple
import Backend
import API

main :: ServerM
main = serve { port: port } { route: api, router: apiRouter }