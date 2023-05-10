module Notes (notes, helloMarkdown) where

foreign import helloMarkdown :: String

notes = { examples: [ helloMarkdown ] }
