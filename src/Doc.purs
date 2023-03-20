module Doc where

import Data.List

data Doc
  = Paragraph Doc
  | Heading String Doc
  | Text String
  | Join (List Doc)

data DocContext
  = Root
  | JoinContext { before :: List Doc, current :: DocContext, after :: List Doc }
