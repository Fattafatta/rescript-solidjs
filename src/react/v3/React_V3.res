/* * Binding to React.element enables the compatibility with v3 */
type element = React.element

@val external null: element = "null"
external float: float => element = "%identity"
external int: int => element = "%identity"
external string: string => element = "%identity"
external array: array<element> => element = "%identity"

type componentLike<'props, 'return> = React.componentLike<'props, 'return>
type component<'props> = React.component<'props>

/* this function exists to prepare for making `component` abstract */
external component: componentLike<'props, element> => component<'props> = "%identity"

@module("../hyper.js")
external createElement: (component<'props>, 'props) => element = "createElement"

@variadic @module("../hyper.js")
external createElementVariadic: (component<'props>, 'props, array<element>) => element =
  "createElement"

// type ref<'value> = React.ref<'value> = {mutable current: 'value}

module Fragment = {
  let name = "frgmnt"
}
