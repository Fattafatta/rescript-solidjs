type element

@val external null: element = "null"
external float: float => element = "%identity"
external int: int => element = "%identity"
external string: string => element = "%identity"
external array: array<element> => element = "%identity"

type componentLike<'props, 'return> = 'props => 'return
type component<'props> = componentLike<'props, element>

@module("./hyper.js")
external createElement: (component<'props>, 'props) => element = "createElement"

@variadic @module("./hyper.js")
external createElementVariadic: (component<'props>, 'props, array<element>) => element =
  "createElement"

module Fragment = {
  let name = "frgmnt"
}
