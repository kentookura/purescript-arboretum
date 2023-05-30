# Mathematical Hypertext in Purescript

Work in progress educational software framework in purescript. I was dissatisfied with the use of Moodle at my university, so I decided to work on something better suited for teaching mathematics. 

I have several goals while working on this project:

* Enable collaborative work on mathematical content. Rather than being just about collaborative text creation, such as [Typst](https://typst.app), it should focus on the creation of non-linear documents. Users should be able to share new notes, definitions and theorems and be able to transclude them in other documents.
* Explore the notion of structured editing in the context of mathematics, see also [polytope](https://github.com/vezwork/Polytope)

## Packages

### Editor ✏️ ️

This package defines an `Editable` type class and a `Deku` component which captures keyboard events to edit an `Editable`.

`Keyboard.purs`: Abstractions for working with the keyboard. 

A big challenge is figuring out how to handle clicks to move the cursor. Maybe I stick with keyboard editing for now. I somehow need to measure the position of clicks.
Also see [purescript-cofree-zipper](https://github.com/kentookura/purescript-cofree-zipper).

### Server 🖥️

>❗ I will probably end up just using a pre-made backend like supabase

For now this is just a playground for learning backend development and `httpurple`.

### Frontend 🕹️




### Reader 👓

A fork of the [deku-documentation](https://github.com/mikesol/deku-documentation). Adds FFI to $\KaTeX$ and Penrose.

TODO: Write a function `Markup -> Page`.

## Examples

To run the e

## Contributing

Contributions are welcome!#

## References/Inspiration

### Elm 

* [Elm RTE Tookit](https://github.com/mweiss/elm-rte-toolkit)

  Prosemirror-inspired library

* [elm-markup](https://github.com/mdgriffith/elm-markup)  

  "A compiled markup language". This might be just a parser combinator 
  library with good error message propagation?

### Rescript

* [darklang](https://github.com/darklang/classic-dark)

  A good reference for a structure editor

### Javascript/Typescript

* [penrose](https://github.com/penrose/penrose),

  DSLs for creating mathematical diagrams

* [polytope](https://github.com/vezwork/Polytope)

  structure editor combinators and other things

### Papers

* [Penrose](https://penrose.cs.cmu.edu/media/Penrose_SIGGRAPH2020a.pdf)
* [hazel](https://github.com/hazelgrove/hazel)
* [Connor McBride, The Derivative of a Regular Type is its Type of One-Hole Contexts](http://strictlypositive.org/diff.pdf)
* [Mohan Ganesalingam, The Language of Mathematics]()
* [M. Ganesalingam, W. T. Gowers, A Fully Automatic Theorem Prover with Human-Style output]()
* [Cyrus Omar, many Others, Toward Semantic Foundations for Program Editors](https://arxiv.org/pdf/1703.08694.pdf)
* [Cyrus Omar, Others, Hazelnut: A Bidirectionally Typed Structure Editor Calculus](https://arxiv.org/pdf/1703.08694.pdf)