module Markup.Syntax where

import Prelude
import Data.List (List(..))
import Data.Maybe (Maybe(..))

data Inline 
  = Str String
  | Space
  | LineBreak
  | SoftBreak
  | Emph (List Inline)
  | Strong (List Inline)
  | Code Boolean String
  | Link (List Inline) LinkTarget

data Block
  = Paragraph (List Inline)
  | Header Int (List Inline)
  | Blockquote (List Block)
  | Lst ListType (List (List Block))
  | CodeBlock CodeBlockType (List String)
  | LinkReference String String
  | Rule

data ListType 
  = Bullet String
  | Ordered String

data CodeBlockType 
  = Indented 
  | Fenced Boolean String

data LinkTarget
  = InlineLink String
  | ReferenceLink (Maybe String)

data Markup = Markup (List Block)

derive instance eqBlock :: Eq Block
derive instance eqInline :: Eq Inline
derive instance eqCodeBlockType :: Eq CodeBlockType
derive instance eqListType :: Eq ListType
derive instance eqLinkTarget :: Eq LinkTarget
derive instance eqMarkup :: Eq Markup

instance showMarkup :: Show Markup where
  show (Markup bs) = "(Markup " <> show bs <> ")"

instance showBlock :: Show Block where
  show (Paragraph is) = "(Paragraph " <> show is <> ")"
  show (Header n is) = "(Header " <> show n <> " " <> show is <> ")"
  show (Blockquote bs) = "(Blockquote " <> show bs <> ")"
  show (Lst lt bss) = "(List " <> show lt <> " " <> show bss <> ")"
  show (CodeBlock ca s) = "(CodeBlock " <> show ca <> " " <> show s <> ")"
  show (LinkReference l uri) = "(LinkReference " <> show l <> " " <> show uri <> ")"
  show Rule = "Rule"

instance showListType :: Show ListType where
  show (Bullet s) = "(Bullet " <> show s <> ")"
  show (Ordered s) = "(Ordered " <> show s <> ")"

instance showCodeBlockType :: Show CodeBlockType where
  show Indented  = "Indented"
  show (Fenced evaluated info) = "(Fenced " <> show evaluated <> " " <> show info <> ")"

instance showInline :: Show Inline where
  show (Str s) = "Str " <> show s <> ")"
  show (Space) = "Space"
  show (LineBreak) = "LineBreak"
  show (SoftBreak) = "SoftBreak"
  show (Emph is) = "(Emph " <> show is <> ")"
  show (Strong is) = "(Strong " <> show is <> ")"
  show (Code e s) = "(Code " <> show e <> " " <> show s <> ")"
  show (Link is tgt) = "(Link " <> show is <> " " <> show tgt <> ")"


instance showLinkTarget :: Show LinkTarget where
  show (InlineLink uri) = "(InlineLink " <> show uri <> ")"
  show (ReferenceLink tgt) = "(ReferenceLink " <> show tgt <> ")"
