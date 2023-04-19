module Watch where

import Prelude

import Effect (Effect)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, runEffectFn1, EffectFn2, runEffectFn2, mkEffectFn2)
import Data.Tuple (Tuple)
import Data.Nullable (Nullable, toMaybe)
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Node.Path (FilePath)
import Node.FS.Async (Callback)

type JSCallback a = EffectFn2 (Nullable Error) a Unit
handleCallback :: forall a. Callback a -> JSCallback a
handleCallback cb = mkEffectFn2 \err a -> case toMaybe err of
  Nothing -> cb (Right a)
  Just err' -> cb (Left err')

foreign import watchImpl :: EffectFn2 FilePath (JSCallback String ) Unit

watch :: FilePath -> Callback String -> Effect Unit
watch p cb = runEffectFn2 watchImpl p (handleCallback cb)