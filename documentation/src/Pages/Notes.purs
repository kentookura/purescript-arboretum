module Pages.Notes where

import Prelude

import Contracts (Page, page, section, subsection)
import Markup.Render (renderMarkup)
import Router.Route (Route(..))

--import Prism (forceHighlight)
--import QualifiedDo.Alt as Alt

notes :: forall lock payload. Page lock payload
notes =
  page
    { route: Notes
    , topmatter: pure []
    , sections:
        [ section
            { title: ""
            , topmatter: pure
                [
                ]
            , subsections:
                [ subsection
                    { title: ""
                    , matter:
                        [ renderMarkup
                            """
# Experimental Interactive Markup Programming

## Ideas

$a=b$

## Notes

Link Considerations:

1. Refer by name
2. Refer by value
3. Refer by identity (hash?) -> hashes not human friendly

Relative/Absolute links
Deep linking -> Consider that the documents should consist of
composable blocks


FRP <-> Differential Equations ??? google this
variable time step


### Devlog

31.03.23:
Added a modified version of the slamdown markdown parser

05.04.23:

Added basic building blocks for the RTE
The only piece of state is the parsed markup at the moment

06.04.23:

Handle more keys.

Notes:
renderMarkup renders the parse error to the DOM. This needs
to be redesigned when using `contentEditable`

Parser changes:
spaces get consolidated while parsing now
keep track of errors by not applying parseErrorMessage 
parse math in dollar signs

TODO:
set up debug view
finish `keyAction`
think about the edit function & types


## References:
elm-rte-toolkit
elm-markup
darklang
texmacs

[Connor McBride, The Derivative of a Regular Type is its Type of One-Hole Contexts](http://strictlypositive.org/diff.pdf)
[Mohan Ganesalingam, The Language of Mathematics]()
[M. Ganesalingam, W. T. Gowers, A Fully Automatic Theorem Prover with Human-Style output]()
[Cyrus Omar, many Others, Toward Semantic Foundations for Program Editors](https://arxiv.org/pdf/1703.08694.pdf)
[Cyrus Omar, Others, Hazelnut: A Bidirectionally Typed Structure Editor Calculus](https://arxiv.org/pdf/1703.08694.pdf)
"""

                        ]
                    }
                ]
            }
        ]
    }
