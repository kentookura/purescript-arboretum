module Markup.Syntax
  ( Markup(..)
  , Inline(..)
  , Block(..)
  , ListType(..)
  , LinkTarget(..)
  , CodeBlockType(..)
  , class Pretty
  , pretty
  , syntaxExample
  , consolidate
  ) where

import Prelude
import Data.Array (fromFoldable)
import Data.List (List(..), (:), length, concat)
import Data.List (fromFoldable) as L
import Data.Maybe (Maybe(..))
import Data.Foldable (foldl)
import Data.String (joinWith)

data Inline
  = Str String
  | Space
  | LineBreak
  | SoftBreak
  | Emph (List Inline)
  | Strong (List Inline)
  | Math (String)
  | Code Boolean String
  | Link (List Inline) LinkTarget

newtype Inlines = Many (List Inline)

data InlineContext
  = Root
  | StringContext { before :: String, after :: String }
  | EmphContext { before :: List InlineContext, after :: List InlineContext }
  | StrongContext { before :: List InlineContext, after :: List InlineContext }
  | CodeContext { before :: String, after :: String }
  | LinkContext

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

instance semigroupMarkup :: Semigroup Markup where
  append (Markup bs) (Markup ds) = Markup (concat (bs : ds : Nil))

consolidate :: List Inline -> List Inline
consolidate =
  case _ of
    Nil -> Nil
    (Str s1) : (Str s2 : is) ->
      consolidate $ Cons (Str (s1 <> s2)) is
    (Str s) : (Space : is) ->
      consolidate $ Cons (Str (s <> " ")) is
    i : is -> Cons i $ consolidate is

instance semigroupInline :: Semigroup Inlines where
  append (Many is) (Many js) = Many (consolidate $ concat $ L.fromFoldable [is, js])

instance showMarkup :: Show Markup where
  show (Markup bs) = "(Markup " <> show bs <> ")"

instance prettyMarkup :: Pretty LinkTarget where
  pretty (InlineLink s) = s
  pretty (ReferenceLink s) = show s


class Pretty a where
  pretty :: a -> String

instance prettyInline :: Pretty Inline where
  pretty = case _ of
    Str s -> s
    Space -> " "
    LineBreak -> "\n\n"
    SoftBreak -> "\n"
    Emph is -> wrap "*" is
    Strong is -> wrap "**" is
    Code _ b -> b
    Math s -> "$" <> s <> "$"
    Link is t -> wrap_ "[" "]" is <> pretty t
    where
    wrap s i = s <> (joinWith "" $ (map pretty (fromFoldable i))) <> s
    wrap_ o c i = o <> (joinWith "" $ (map pretty (fromFoldable i))) <> c

instance prettyBlock :: Pretty Block where
  pretty b = go b 0
    where
    go :: Block -> Int -> String
    go b i = case b of
      Paragraph is ->
        """Paragraph
      """ <> foldl append mempty (map pretty is)
      Header lvl is ->
        "Header (level "
          <> show lvl
          <> ") \""
          <> foldl append mempty (map pretty is)
      Blockquote bs -> "Blockquote" <> foldl append mempty (map pretty bs)
      Lst _ _ -> "List"
      CodeBlock cbtype _ -> "CodeBlock"
      LinkReference s1 s2 -> "LinkReference"
      Rule -> "Rule"

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
  show Indented = "Indented"
  show (Fenced evaluated info) = "(Fenced " <> show evaluated <> " " <> show info <> ")"

instance showInline :: Show Inline where
  show (Str s) = "(Str " <> show s <> ")"
  show (Space) = "Space"
  show (LineBreak) = "LineBreak"
  show (SoftBreak) = "SoftBreak"
  show (Emph is) = "(Emph " <> show is <> ")"
  show (Strong is) = "(Strong " <> show is <> ")"
  show (Code e s) = "(Code " <> show e <> " " <> show s <> ")"
  show (Link is tgt) = "(Link " <> show is <> " " <> show tgt <> ")"
  show (Math is) = "(Math " <> show is <> ")"

instance showLinkTarget :: Show LinkTarget where
  show (InlineLink uri) = "(InlineLink " <> show uri <> ")"
  show (ReferenceLink tgt) = "(ReferenceLink " <> show tgt <> ")"

syntaxExample :: Markup
syntaxExample = Markup (Header 1 (Str "Parse" : Space : Str "this" : Space : Str "Header!" : Nil) : Nil)