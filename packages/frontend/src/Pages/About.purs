module Pages.About where

import Prelude

import Components.Icon as Icon
import Components.MarkdownDemo (formulas)
import Data.Either (Either(..))
import Data.Foldable (for_, traverse_)
import Data.Tuple (curry, Tuple(..), fst, snd, uncurry)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_, text, (<#~>), (<$~>), blank)
import Deku.Core (Nut, envy)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState, useState', useHot', useDynAtBeginning, useEffect)
import Deku.Listeners (click, click_, keyUp)
import Deku.Toplevel (runInBody)
import Effect.Class.Console (logShow)
import FRP.Event.Class ((<**|>), (<|*>), (<*|>))
import Text.Markdown.SlamDown.Parser (parseMd)
import Text.Markdown.SlamDown.Render (renderMd, renderMdFromString)
import Text.Markdown.SlamDown.Syntax (SlamDownP)
import Web.Event.Event (target)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.UIEvent.KeyboardEvent (code, toEvent)

about :: Nut
about = Deku.do
  formulas
