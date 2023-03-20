module Pages.Docs
  where

import Prelude

import Contracts (Docs(..))
import Data.Maybe (Maybe(..))
--import Pages.AdvancedUsage (advancedUsage)
--import Pages.CoreConcepts (coreConcepts)
--import Pages.FRP (frp)
import Pages.Introduction (introduction)


docs :: forall lock payload. Docs lock payload
docs = Docs [ introduction ]

data
    Doc
    -- Just raw text embedded in a doc. Will be unbroken.
    = Word String
      -- Inline monospace, as in ''some monospace code''.
    | Code Doc
      -- Block monospace with syntax highlighting.
      -- ''' blocks are parsed as ``` raw
    | CodeBlock String Doc
    | Bold Doc
    | Italic Doc
    | Strikethrough Doc
      -- Can be used to affect HTML rendering
    | Style String Doc
      -- Create a named fragment/target anchor point which can be used in
      -- links that will result in urls like
      -- https://unison-lang.org/#section1
    | Anchor String Doc
    | Blockquote Doc
    | Blankline
    | Linebreak
      -- For longer sections, this inserts a doodad or thingamajig
    | SectionBreak
      -- Tooltip inner tooltipContent
    | Tooltip Doc Doc
      -- Aside asideContent
    | Aside Doc
      -- Callout icon content
    | Callout (Maybe Doc) Doc
      -- If folded, only summary is shown, otherwise
      -- summary is followed by details. Some renderers
      -- will present this as a toggle or clickable elipses
    -- | Folded { foldId :: FoldId, isFolded :: Bool, summary :: Doc, details :: Doc }
      -- Documents separated by spaces and wrapped to available width
    | Span (Array Doc)
    | BulletedList (Array Doc)
      -- NumberedList startingNumber listElements
    | NumberedList Int (Array Doc)
      -- Section title subelements
    | Section Doc (Array Doc)
      -- [our website](https://unisonweb.org) or [blah]({type MyType})
    | NamedLink Doc Doc
      -- image alt-text link caption
    | Image Doc Doc (Maybe Doc)
    -- | Special SpecialForm
      -- Concatenation of docs
    | Join (Array Doc)
      -- A section with no title but otherwise laid out the same
    | UntitledSection (Array Doc)
      -- A list of documents that should start on separate lines;
      -- this is used for nested lists, for instance
      -- * docA
      --   * A.1
      --   * A.2
      -- * B
      --   * B.1
      --   * B.2
      -- Is modeled as:
      --   BulletedList [ Column [A, BulletedList [A.1, A.2]]
      --                , Column [B, BulletedList [B.1, B.2]]
    | Column (Array Doc)
      -- Sometimes useful in paragraph text to avoid line breaks in
      -- awkward places
    | Group Doc