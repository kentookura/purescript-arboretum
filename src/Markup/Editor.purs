module Markup.Editor
  ( BlockTypes(..)
  , Editor(..)
  , Spec(..)
  , editor
  , Config(..)
  )
  where

import Prelude
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Core (Nut)
import Deku.DOM as D
import QualifiedDo.Alt as Alt
import Markup.Syntax (Markup)

data Edit = Edit
data BlockTypes = MarkupBlocks | Custom String
type Spec = { blocks :: Array BlockTypes}
data Config = Config {spec :: Spec}
data Editor = Editor {
  content :: Markup
}
editor :: Config -> Editor -> Nut
editor cfg editor = Deku.do
  D.div
    (Alt.do
      D.Contenteditable !:= "true"
      klass_ "editor-main"
      -- ""
--      D.OnKeydown !:= do
    )
    [
    -- viewEditorBlocks
    ]

--viewEditorBlocks :: Nut
