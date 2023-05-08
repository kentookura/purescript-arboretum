# Structured Editing with Purescript

Work in progress structure editing framework in purescript.

`documentation` contains a copy of the [deku documentation](https://github.com/mikesol/deku-documentation) with some pages demonstrating some FFI bindings to [Penrose](https://penrose.cs.cmu.edu) and $\KaTeX$. Currently working on

## [Demo](https://purescript-editor.netlify.app)






## TODO

Enhance links to support document transclusion
Write a zipper for the Markdown AST.

### References/Inspiration

#### Elm 

* [Elm RTE Tookit](https://github.com/mweiss/elm-rte-toolkit)

  Prosemirror-inspired library

* [elm-markup](https://github.com/mdgriffith/elm-markup)  

  "A compiled markup language". This might be just a parser combinator 
  library with good error message propagation?

#### Rescript

* [darklang](https://github.com/darklang/classic-dark)

  A good reference

#### Javascript/Typescript

* [penrose](https://github.com/penrose/penrose),

  DSLs for creating mathematical diagrams

* [polytope](https://github.com/vezwork/Polytope)

  structure editor combinators and other things

#### Papers

* [Penrose](https://penrose.cs.cmu.edu/media/Penrose_SIGGRAPH2020a.pdf)
* [hazel](https://github.com/hazelgrove/hazel)
* [Connor McBride, The Derivative of a Regular Type is its Type of One-Hole Contexts](http://strictlypositive.org/diff.pdf)
* [Mohan Ganesalingam, The Language of Mathematics]()
* [M. Ganesalingam, W. T. Gowers, A Fully Automatic Theorem Prover with Human-Style output]()
* [Cyrus Omar, many Others, Toward Semantic Foundations for Program Editors](https://arxiv.org/pdf/1703.08694.pdf)
* [Cyrus Omar, Others, Hazelnut: A Bidirectionally Typed Structure Editor Calculus](https://arxiv.org/pdf/1703.08694.pdf)