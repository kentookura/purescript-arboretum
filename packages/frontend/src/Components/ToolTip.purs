module Components.ToolTip where

import FRP.Event (Event)
import Deku.Core (Nut)
import Deku.Control ((<#~>), blank, text_)
import Deku.DOM as D

type ToolTipProps = { content :: Nut, text :: String }

tooltip :: ToolTipProps -> Nut
tooltip props = D.div [] [ D.button [] [ text_ props.text ], D.div_ [ props.content ] ]

showIf :: Event Boolean -> Nut -> Nut
showIf e n = e <#~> if _ then n else blank