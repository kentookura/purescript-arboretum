module Frontend.Components.Icon where

import Deku.DOM as D
import Deku.Do as Deku
import Deku.Core (Nut)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)

icon :: String -> Nut
icon s = Deku.do
  D.svg
    [ D.Fill !:= "none"
    , D.ViewBox !:= "0 0 24 24"
    , D.StrokeWidth !:= "1.5"
    , D.Stroke !:= "currentColor"
    , klass_ "w-4 h-4"
    ]
    [ D.path
        [ D.StrokeLinecap !:= "round"
        , D.StrokeLinejoin !:= "round"
        , D.D !:= s
        ]
        []
    ]
