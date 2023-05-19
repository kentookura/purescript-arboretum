module Data.Search.Trie
  ( Trie(..)
  , Ctx(..)
  , Zipper(..)
  , alter
  , delete
  , deleteByPrefix
  , descend
  , entries
  , entriesUnordered
  , eq'
  , follow
  , fromFoldable
  , fromList
  , fromZipper
  , insert
  , isEmpty
  , lookup
  , mkZipper
  , prune
  , query
  , queryValues
  , size
  , subtrie
  , subtrieWithPrefixes
  , toUnfoldable
  , update
  , values
  ) where

import Prelude

import Data.Array as A
import Data.Foldable (class Foldable, foldl)
import Data.List (List(..), (:))
import Data.List as L
import Data.Map (Map)
import Data.Map as M
import Data.Maybe (Maybe(..))
import Data.Maybe as MB
import Data.Tuple (Tuple(..), snd, uncurry)
import Data.Bifunctor (lmap, rmap)
import Data.Unfoldable (class Unfoldable)

data Trie k v
  = Branch (Maybe v) (Map k (Trie k v))
  -- `Arc` lengths are saved in the structure to speed up lookups.
  -- `List` was chosen because of better asymptotics of its `drop`
  -- operation, in comparison with `Data.Array.drop`.
  -- The list is always non-empty.
  | Arc Int (List k) (Trie k v)

instance eqTrie :: (Eq k, Eq v) => Eq (Trie k v) where
  eq a b = entries a == entries b

instance showTrie :: (Show k, Show v) => Show (Trie k v) where
  show trie = "fromFoldable " <> show (toUnfoldable trie :: Array (Tuple (Array k) v))

instance semigroupTrie :: Ord k => Semigroup (Trie k v) where
  append a b =
    foldl (flip $ uncurry insert) b $ entries a

instance monoidTrie :: Ord k => Monoid (Trie k v) where
  mempty = empty

instance functorTrie :: Ord k => Functor (Trie k) where
  map f trie = fromList $ entriesUnordered trie <#> rmap f

-- | Check that two tries are not only equal, but also have the same internal structure.
eq'
  :: forall k v
   . Eq k
  => Eq v
  => Trie k v
  -> Trie k v
  -> Boolean
eq' (Branch mbValue1 children1) (Branch mbValue2 children2) =
  if mbValue1 == mbValue2 then
    let
      childrenList1 = M.toUnfoldable children1
      childrenList2 = M.toUnfoldable children2
    in
      if A.length childrenList1 == A.length childrenList2 then A.all identity $
        A.zipWith
          ( \(Tuple k1 v1) (Tuple k2 v2) ->
              if k1 == k2 then
                eq' v1 v2
              else
                false
          )
          childrenList1
          childrenList2
      else false
  else false
eq' (Arc len1 path1 child1) (Arc len2 path2 child2) =
  len1 == len2 && path1 == path2 && eq' child1 child2
eq' _ _ = false

-- | A smart constructor to ensure Arc non-emptiness.
mkArc
  :: forall k v
   . List k
  -> Trie k v
  -> Trie k v
mkArc Nil trie = trie
mkArc arc trie = Arc (L.length arc) arc trie

empty
  :: forall k v
   . Ord k
  => Trie k v
empty = Branch Nothing mempty

isEmpty
  :: forall k v
   . Trie k v
  -> Boolean
isEmpty = isEmpty' <<< L.singleton
  where
  isEmpty' Nil = true
  isEmpty' (Branch (Just _) _ : _) = false
  isEmpty' (Branch _ children : rest) = isEmpty' $
    (snd <$> M.toUnfoldableUnordered children) <> rest
  isEmpty' (Arc _ _ child : rest) =
    isEmpty' (child : rest)

-- | Number of elements in a trie.
size
  :: forall k v
   . Trie k v
  -> Int
size = go 0 <<< L.singleton
  where
  go acc Nil = acc
  go acc (Branch mbValue children : rest) =
    go (MB.maybe acc (const (acc + 1)) mbValue)
      ((snd <$> M.toUnfoldableUnordered children) <> rest)
  go acc (Arc _ _ child : rest) =
    go acc (child : rest)

data Ctx k v
  = BranchCtx (Maybe v) k (Map k (Trie k v))
  | ArcCtx Int (List k)

data Zipper k v = Zipper (Trie k v) (List (Ctx k v))

mkZipper
  :: forall k v
   . Trie k v
  -> Zipper k v
mkZipper trie = Zipper trie Nil

withZipper
  :: forall k v
   . Ord k
  => (Zipper k v -> Zipper k v)
  -> Trie k v
  -> Trie k v
withZipper f trie = fromZipper (f (mkZipper trie))

fromZipper
  :: forall k v
   . Ord k
  => Zipper k v
  -> Trie k v
fromZipper (Zipper trie (Cons ctx ctxs)) =
  case ctx, trie of
    BranchCtx mbValue key other, _ ->
      fromZipper (Zipper (Branch mbValue $ M.insert key trie other) ctxs)

    ArcCtx len1 path1, Arc len2 path2 child ->
      fromZipper (Zipper (Arc (len1 + len2) (path1 <> path2) child) ctxs)

    ArcCtx len path, _ ->
      fromZipper (Zipper (Arc len path trie) ctxs)
fromZipper (Zipper trie Nil) = trie

-- | Delete everything until the first non-empty context.
prune
  :: forall k v
   . Ord k
  => List (Ctx k v)
  -> Zipper k v
prune ctxs =
  case ctxs of
    BranchCtx mbValue key children : rest ->
      let
        newChildren = M.delete key children
      in
        if MB.isJust mbValue || not (M.isEmpty newChildren) then Zipper (Branch mbValue newChildren) rest
        else prune rest
    ArcCtx len path : rest ->
      prune rest
    Nil -> mkZipper mempty

-- | Follows a given path, constructing new branches as necessary.
-- | Returns the contents of the last branch with context from which the trie
-- | can be restored using `fromZipper`.
descend
  :: forall k v
   . Ord k
  => List k
  -> Zipper k v
  -> { mbValue :: Maybe v
     , children :: Map k (Trie k v)
     , ctxs :: List (Ctx k v)
     }
descend Nil (Zipper (Branch mbValue children) ctxs) =
  { mbValue, children, ctxs }
descend (head : tail) (Zipper (Branch mbOldValue children) ctxs) =
  case M.lookup head children of
    Just child ->
      descend tail $
        Zipper child (BranchCtx mbOldValue head children : ctxs)
    Nothing -> { mbValue: Nothing, children: mempty, ctxs: ctxs' }
      where
      -- Create a new empty trie, place it at the end of a new arc.
      branchCtxs = BranchCtx mbOldValue head children : ctxs
      ctxs' =
        if L.null tail then branchCtxs
        else ArcCtx (L.length tail) tail : branchCtxs
descend path (Zipper (Arc len arc child) ctxs) =
  let
    prefixLength = longestCommonPrefixLength path arc
  in
    if prefixLength == len then
      let
        newPath = L.drop prefixLength path
      in
        descend newPath $
          Zipper child (ArcCtx len arc : ctxs)
    else if prefixLength == 0 then
      -- Replace `Arc` with a `Branch`.
      case L.uncons arc of
        Just { head, tail } ->
          -- We want to avoid `L.length` call on `tail`: at this point
          -- the length can be calculated.
          let
            len' = len - 1
            children = M.singleton head $
              if len' > 0 then Arc len' tail child
              else child
          in
            descend path $
              Zipper (Branch Nothing children) ctxs
        Nothing ->
          -- Impossible: `arc` is always non-empty
          { mbValue: Nothing
          , children: mempty
          , ctxs
          }
    else
      let
        outerArc = L.take prefixLength path
        newPath = L.drop prefixLength path
        -- `innerArc` is always non-empty, because
        -- `prefixLength == L.length arc` is false in this branch.
        -- `prefixLength <= L.length arc` is true because `prefixLength` is
        -- a length of some prefix of `arc`.
        -- Thus `prefixLength < L.length arc`.
        innerArc = L.drop prefixLength arc
        innerArcLength = len - prefixLength
        outerArcLength = L.length outerArc
      in
        descend newPath $
          Zipper (Arc innerArcLength innerArc child)
            if outerArcLength == 0 then ctxs
            else ArcCtx outerArcLength outerArc : ctxs

-- | Follows a given path, but unlike `descend`, fails instead of creating new
-- | branches.
follow
  :: forall k v
   . Ord k
  => List k
  -> Zipper k v
  -> Maybe
       { mbValue :: Maybe v
       , children :: Map k (Trie k v)
       , ctxs :: List (Ctx k v)
       }
follow Nil (Zipper (Branch mbValue children) ctxs) =
  Just { mbValue, children, ctxs }
follow (head : tail) (Zipper (Branch mbOldValue children) ctxs) =
  case M.lookup head children of
    Just child ->
      follow tail $ Zipper child (BranchCtx mbOldValue head children : ctxs)
    Nothing ->
      Nothing
follow path (Zipper (Arc len arc child) ctxs) =
  let
    prefixLength = longestCommonPrefixLength path arc
  in
    if prefixLength == len then
      let
        newPath = L.drop prefixLength path
      in
        follow newPath $ Zipper child (ArcCtx len arc : ctxs)
    else
      Nothing

lookup
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> Maybe v
lookup path trie =
  follow path (mkZipper trie) >>= _.mbValue

-- | Update the entry at a given path.
update
  :: forall k v
   . Ord k
  => (v -> v)
  -> List k
  -> Trie k v
  -> Trie k v
update f path trie =
  case follow path (mkZipper trie) of
    Just { mbValue, children, ctxs } ->
      fromZipper $ Zipper (Branch (f <$> mbValue) children) ctxs
    _ -> trie

-- | Delete the entry at a given path.
delete
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> Trie k v
delete path trie =
  case follow path (mkZipper trie) of
    Just { mbValue, children, ctxs } ->
      fromZipper $
        if M.isEmpty children then
          prune ctxs
        else
          Zipper (Branch Nothing children) ctxs
    _ -> trie

-- | Delete all entries by a given path prefix.
deleteByPrefix
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> Trie k v
deleteByPrefix path trie =
  fromZipper $ prune (descend path (mkZipper trie)).ctxs

-- | Returns a subtrie containing all paths with given prefix. Path prefixes are not saved.
subtrie
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> Maybe (Trie k v)
subtrie Nil trie = Just trie
subtrie path (Arc len arc child) =
  let
    prefixLength = longestCommonPrefixLength path arc
  in
    if prefixLength == 0 then Nothing
    else subtrie (L.drop prefixLength path)
      if prefixLength == len then child
      else mkArc (L.drop prefixLength arc) child
subtrie (head : tail) trie@(Branch _ children) =
  case M.lookup head children of
    Just trie' -> subtrie tail trie'
    Nothing -> Nothing

-- | A version of `subtrie` that does not cut the prefixes.
subtrieWithPrefixes
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> Maybe (Trie k v)
subtrieWithPrefixes path trie =
  fromFoldable
    <<< map (lmap (path <> _))
    <<<
      entriesUnordered <$>
    subtrie path trie

query
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> List (Tuple (List k) v)
query path =
  entries <<< MB.fromMaybe empty <<< subtrieWithPrefixes path

queryValues
  :: forall k v
   . Ord k
  => List k
  -> Trie k v
  -> List v
queryValues path =
  values <<< MB.fromMaybe mempty <<< subtrie path

-- | Insert an entry into a trie.
insert
  :: forall k v
   . Ord k
  => List k
  -> v
  -> Trie k v
  -> Trie k v
insert path value trie =
  case descend path (mkZipper trie) of
    { mbValue, children, ctxs } ->
      fromZipper $ Zipper (Branch (Just value) children) ctxs

-- | Delete, insert or update the entry by a given path.
-- | It is recommended to use specialized functions for each case.
alter
  :: forall k v
   . Ord k
  => List k
  -> (Maybe v -> Maybe v)
  -> Trie k v
  -> Trie k v
alter path =
  withZipper <<< alter' path

alter'
  :: forall k v
   . Ord k
  => List k
  -> (Maybe v -> Maybe v)
  -> Zipper k v
  -> Zipper k v
alter' path f zipper =
  case descend path zipper of
    { mbValue, children, ctxs } ->
      let
        updatedValue = f mbValue
        wasDeleted = MB.isJust mbValue
          && MB.isNothing updatedValue
          &&
            M.isEmpty children
      in
        if wasDeleted then
          -- Remove unused branches and arcs from the tree.
          prune ctxs
        else Zipper (Branch updatedValue children) ctxs

fromList
  :: forall k v
   . Ord k
  => List (Tuple (List k) v)
  -> Trie k v
fromList =
  foldl (flip (uncurry insert)) empty

fromFoldable
  :: forall f p k v
   . Ord k
  => Foldable f
  => Foldable p
  => f (Tuple (p k) v)
  -> Trie k v
fromFoldable =
  foldl (flip (lmap L.fromFoldable >>> uncurry insert)) empty

-- | Resulting List will be sorted.
entries
  :: forall k v
   . Trie k v
  -> List (Tuple (List k) v)
entries =
  entriesWith M.toUnfoldable

-- | A version of `entries` defined using [Data.Map.toUnfoldableUnordered](https://pursuit.purescript.org/packages/purescript-ordered-collections/docs/Data.Map#v:toUnfoldableUnordered).
entriesUnordered
  :: forall k v
   . Trie k v
  -> List (Tuple (List k) v)
entriesUnordered =
  entriesWith M.toUnfoldableUnordered

entriesWith
  :: forall k v
   . (Map k (Trie k v) -> List (Tuple k (Trie k v)))
  -> Trie k v
  -> List (Tuple (List k) v)
entriesWith mapToUnfoldable trie =
  L.reverse $
    lmap (L.concat <<< L.reverse) <$>
      go (L.singleton $ Tuple trie Nil) Nil
  where
  go
    :: List (Tuple (Trie k v) (List (List k)))
    -> List (Tuple (List (List k)) v)
    -> List (Tuple (List (List k)) v)
  go (Tuple (Branch mbValue children) chunks : queue) res =
    let
      childrenQueue =
        mapToUnfoldable children <#>
          \(Tuple key child) ->
            Tuple child (L.singleton key : chunks)
    in
      go (childrenQueue <> queue)
        ( case mbValue of
            Just value ->
              Tuple chunks value : res
            Nothing -> res
        )
  go (Tuple (Arc _ path child) chunks : queue) res =
    go (Tuple child (path : chunks) : queue) res
  go Nil res = res

toUnfoldable
  :: forall f p k v
   . Unfoldable f
  => Unfoldable p
  => Trie k v
  -> f (Tuple (p k) v)
toUnfoldable trie =
  L.toUnfoldable (entries trie <#> lmap L.toUnfoldable)

values
  :: forall k v
   . Trie k v
  -> List v
values = L.reverse <<< go Nil <<< L.singleton
  where
  go res Nil = res
  go res (Branch mbValue children : queue) =
    go
      ( case mbValue of
          Just value -> value : res
          Nothing -> res
      )
      (M.values children <> queue)
  go res (Arc len path child : queue) =
    go res (child : queue)

longestCommonPrefixLength :: forall a. Eq a => List a -> List a -> Int
longestCommonPrefixLength = go 0
  where
  go n xs ys =
    case L.uncons xs, L.uncons ys of
      Just x, Just y ->
        if x.head == y.head then go (n + 1) x.tail y.tail
        else n
      _, _ -> n