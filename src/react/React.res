type element = Jsx.element

@val external null: element = "null"
external float: float => element = "%identity"
external int: int => element = "%identity"
external string: string => element = "%identity"
external array: array<element> => element = "%identity"

type componentLike<'props, 'return> = Jsx.componentLike<'props, 'return>

type component<'props> = Jsx.component<'props>

external component: componentLike<'props, element> => component<'props> = "%identity"

@module("./hyper.js")
external createElement: (component<'props>, 'props) => element = "createElement"

@variadic @module("./hyper.js")
external createElementVariadic: (component<'props>, 'props, array<element>) => element =
  "createElement"

external jsx: (component<'props>, 'props) => element = "JsxRuntime.jsx"

external jsxKeyed: (component<'props>, 'props, ~key: string=?, @ignore unit) => element =
  "JsxRuntime.jsx"

external jsxs: (component<'props>, 'props) => element = "JsxRuntime.jsx"

external jsxsKeyed: (component<'props>, 'props, ~key: string=?, @ignore unit) => element =
  "JsxRuntime.jsx"

type fragmentProps<'children> = {children?: 'children}

external jsxFragment: component<fragmentProps<'children>> = "JsxRuntime.Fragment"

// type ref<'value> = {mutable current: 'value}

external fragment: 'a = "React.Fragment"

module Fragment = {
  type props<'children> = {key?: string, children: 'children}

  let name = "frgmnt"

  external make: component<props<'children>> = "JsxRuntime.Fragment"
}
