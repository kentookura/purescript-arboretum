module Components.Icon where

import Prelude
import Data.Array (zipWith)
import Data.Foldable (foldMap)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Core (Nut)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)

type Size = Int
type Path = String

icon :: Size -> Path -> Nut
icon i path = Deku.do
  let sizeKls = foldMap (_ <> show i <> " ") [ "h-", "w-" ]
  D.svg
    [ klass_ $ sizeKls <> " shrink-0"
    , D.Fill !:= "none"
    , D.ViewBox !:= "0 0 " <> show (i * 4) <> " " <> show (i * 4)
    , D.StrokeWidth !:= "1.5"
    , D.Stroke !:= "currentColor"
    , D.AriaHidden !:= "true"
    ]
    [ D.path
        [ D.StrokeLinecap !:= "round"
        , D.StrokeLinejoin !:= "round"
        , D.D !:= path
        ]
        []
    ]

home = icon 6 "M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"

team = icon 6 "M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z"

calendar = icon 6 "M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5"

documents = icon 6 "M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 01-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 011.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 00-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 01-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 00-3.375-3.375h-1.5a1.125 1.125 0 01-1.125-1.125v-1.5a3.375 3.375 0 00-3.375-3.375H9.75"

xmark = icon 6 "M6 18L18 6M6 6l12 12"