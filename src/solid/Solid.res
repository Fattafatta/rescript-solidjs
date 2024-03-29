type accessor<'value> = unit => 'value
type setter<'value> = ('value => 'value) => unit
type signal<'value> = (accessor<'value>, setter<'value>)
type thunk<'m> = unit => 'm
type unitToUnit = unit => unit
type boolOpt = {equals: bool}
type comparatorOpt<'a> = {equals: ('a, 'a) => bool}

type reactive<'r> = 'r
external track: (unit => 'reactive) => reactive<'reactive> = "%identity"

@module("../react/hyper.js") @variadic
external makeClassList: array<(string, bool)> => ReactDOM.classList = "makeClassList"

module Event = Solid_Event

// @module("solid-js")
// external createSignal: 'value => signal<'value> = "createSignal"

@module("solid-js")
external createSignal: (
  'value,
  ~options: @unwrap
  [
    | #bool(boolOpt)
    | #fn(comparatorOpt<'a>)
  ]=?,
  unit,
) => signal<'value> = "createSignal"

@module("solid-js")
external createEffect: ('value => 'value, ~value: 'value=?, unit) => unit = "createEffect"

@module("solid-js")
external createMemo: (
  'value => 'value,
  ~value: 'value=?,
  ~options: @unwrap
  [
    | #bool(boolOpt)
    | #fn(comparatorOpt<'a>)
  ]=?,
  unit,
) => thunk<'value> = "createMemo"

@module("solid-js")
external createMemoUnit: (
  unit => 'value,
  ~value: 'value=?,
  ~options: @unwrap
  [
    | #bool(boolOpt)
    | #fn(comparatorOpt<'a>)
  ]=?,
  unit,
) => thunk<'value> = "createMemo"

// TODO: Add support for refetch value "unknown" info to createResource
module Resource = {
  type info<'value> = {value: option<'value>, refetching: bool}
  type fetchData<'source, 'value> = ('source, info<'value>) => promise<'value>

  type properties<'value> = {
    mutate: option<'value> => option<'value>,
    refetch: unit => promise<'value>,
  }

  type options<'value, 'unknown> = {
    initialValue?: 'value,
    name?: string,
    deferStream?: bool,
    ssrLoadFrom?: [#initial | #server],
    storage?: option<'value> => signal<option<'value>>,
    onHydrated?: (option<'unknown>, info<'value>) => unit,
  }

  @module("solid-js")
  external make: (
    ~source: accessor<'source>=?,
    fetchData<'source, 'value>,
    ~options: options<'value, 'unknown>=?,
    unit,
  ) => (accessor<option<'value>>, properties<'value>) = "createResource"

  let make: (
    ~source: accessor<'source>=?,
    fetchData<'source, 'value>,
    ~options: options<'value, 'unknown>=?,
    unit,
  ) => (accessor<option<'value>>, properties<'value>) = (
    ~source=true->Obj.magic,
    fetcher,
    ~options=?,
    u,
  ) => make(~source, fetcher, ~options=options->Obj.magic, u)

  type optionsWithInitial<'value, 'unknown> = {
    initialValue: 'value,
    name?: string,
    deferStream?: bool,
    ssrLoadFrom?: [#initial | #server],
    storage?: option<'value> => signal<option<'value>>,
    onHydrated?: (option<'unknown>, info<'value>) => unit,
  }

  @module("solid-js")
  external makeWithInitial: (
    ~source: accessor<'source>,
    fetchData<'source, 'value>,
    ~options: optionsWithInitial<'value, 'unknown>,
    unit,
  ) => (accessor<'value>, properties<'value>) = "createResource"

  let makeWithInitial: (
    ~source: accessor<'source>=?,
    fetchData<'source, 'value>,
    ~options: optionsWithInitial<'value, 'unknown>,
    unit,
  ) => (accessor<'value>, properties<'value>) = (~source=true->Obj.magic, fetcher, ~options, u) =>
    makeWithInitial(~source, fetcher, ~options, u)

  @get external loading: accessor<'value> => bool = "loading"
  @get external error: accessor<'value> => 'any = "error"
  @get external latest: accessor<'value> => 'value = "latest"
  @get
  external state: accessor<'value> => [#unresolved | #pending | #ready | #refreshing | #errored] =
    "state"
}

@module("solid-js")
external onMount: (unit => unit) => unit = "onMount"

@module("solid-js")
external onCleanup: (unit => unit) => unit = "onCleanup"

@module("solid-js")
external onError: ('error => unit) => unit = "onError"

@module("solid-js")
external untrack: (unit => 'value) => 'value = "untrack"

@module("solid-js")
external batch: (unit => 'value) => 'value = "batch"

type onReturn<'return> = option<'return> => option<'return>
type onOptions = {defer: bool}
@module("solid-js")
external on: (
  accessor<'val>,
  ('val, 'val, option<'return>) => 'return,
  ~options: onOptions=?,
  unit,
) => onReturn<'return> = "on"

@module("solid-js")
external on2: (
  (accessor<'v1>, accessor<'v2>),
  (('v1, 'v2), ('v1, 'v2), option<'r>) => 'r,
  ~options: onOptions=?,
  unit,
) => onReturn<'r> = "on"

@module("solid-js")
external on3: (
  (accessor<'v1>, accessor<'v2>, accessor<'v3>),
  (('v1, 'v2, 'v3), ('v1, 'v2, 'v3), option<'r>) => 'r,
  ~options: onOptions=?,
  unit,
) => onReturn<'r> = "on"

@module("solid-js")
external on4: (
  (accessor<'v1>, accessor<'v2>, accessor<'v3>, accessor<'v4>),
  (('v1, 'v2, 'v3, 'v4), ('v1, 'v2, 'v3, 'v4), option<'r>) => 'r,
  ~options: onOptions=?,
  unit,
) => onReturn<'r> = "on"

@module("solid-js")
external on5: (
  (accessor<'v1>, accessor<'v2>, accessor<'v3>, accessor<'v4>, accessor<'v5>),
  (('v1, 'v2, 'v3, 'v4, 'v5), ('v1, 'v2, 'v3, 'v4, 'v5), option<'r>) => 'r,
  ~options: onOptions=?,
  unit,
) => onReturn<'r> = "on"

@module("solid-js")
external createRoot: ((unit => unit) => 'value) => 'value = "createRoot"

type owner
@module("solid-js")
external getOwner: unit => owner = "getOwner"

@module("solid-js")
external runWithOwner: (owner, (unit => unit) => 'value) => 'value = "runWithOwner"

@module("solid-js")
external mergeProps: ('left, 'right) => 'full = "mergeProps"

@variadic @module("solid-js")
external mergePropsVariadic: array<'full> => 'full = "mergeProps"

@module("solid-js")
external splitProps: ('value, array<string>) => ('selected, 'other) = "splitProps"
@module("solid-js")
external splitProps2: ('value, array<string>, array<string>) => ('selected, 'selected2, 'other) =
  "splitProps"
@module("solid-js")
external splitProps3: (
  'value,
  array<string>,
  array<string>,
  array<string>,
) => ('selected, 'selected2, 'selected3, 'other) = "splitProps"
@module("solid-js")
external splitProps4: (
  'value,
  array<string>,
  array<string>,
  array<string>,
  array<string>,
) => ('selected, 'selected2, 'selected3, 'selected3, 'other) = "splitProps"
@module("solid-js")
external splitProps5: (
  'value,
  array<string>,
  array<string>,
  array<string>,
  array<string>,
  array<string>,
) => ('selected, 'selected2, 'selected3, 'selected3, 'selected5, 'other) = "splitProps"

@module("solid-js")
external useTransition: unit => (unit => bool, thunk<unit> => promise<unit>) = "useTransition"

@module("solid-js")
external startTransition: (unit => unit) => promise<unit> = "startTransition"

// TODO: Add "observable"
// type observable<'value>
// @module("solid-js")
// external observable: (unit => 'value) => observable<'value> = "observable"

// TODO: Add "from"

type mapOptions = {fallback: unit => React.element}
@module("solid-js")
external mapArray: (
  unit => array<'value>,
  'value => 'result,
  ~options: mapOptions=?,
  unit,
) => thunk<array<'result>> = "mapArray"
@module("solid-js")
external mapArrayi: (
  unit => array<'value>,
  ('value, unit => int) => 'result,
  ~options: mapOptions=?,
  unit,
) => thunk<array<'result>> = "mapArray"

@module("solid-js")
external indexArray: (
  unit => array<'value>,
  (unit => 'value, int) => 'result,
  ~options: mapOptions=?,
  unit,
) => thunk<array<'result>> = "indexArray"

module Store = {
  // TODO: This allows passing of non store objects to functions (like unwrap) that require a store object.
  // But since the orginal signature of createStore is "T | Store<T>", this was the easiest solution.
  type t<'store> = 'store
  type setStore<'store> = ('store => 'store) => unit

  @module("solid-js/store")
  external make: 'store => (t<'store>, setStore<'store>) = "createStore"

  // @module("solid-js/store")
  // external createStore: 'store => (t<'store>, setStore<'store>) = "createStore"

  // TODO: Add "produce"
  // TODO: Add "reconcile"

  @module("solid-js/store")
  external unwrap: t<'store> => 'store = "unwrap"

  // TODO: Add "createMutable"
  // TODO: Add "modifyMutable"
}

module Context = {
  module type Provider = {
    type props<'value> = {value: 'value, children: React.element}
    let make: React.component<props<'value>>
  }
  type t<'value> = {
    id: Js.Types.symbol,
    @as("Provider") provider: module(Provider),
    defaultValue: option<'value>,
  }
  @module("solid-js")
  external make: 'value => t<'value> = "createContext"

  let make = val => {
    let ext = make(val)
    {
      id: ext.id,
      defaultValue: ext.defaultValue,
      provider: {
        "make": ext.provider,
      }->Obj.magic,
    }
  }

  @module("solid-js")
  external useContext: t<'value> => 'value = "useContext"
}

@module("solid-js")
let createContext: 'value => Context.t<'value> = Context.make

@module("solid-js")
external useContext: Context.t<'value> => 'value = "useContext"

type reactelement
type children<'a> = React.element
type resolved = unit => children<reactelement>
@module("solid-js")
external children: (unit => React.element) => resolved = "children"

module Lazy: {
  module type T = {
    type props = {}
    let make: React.component<props>
  }
  type import
  let make: (unit => import) => module(T)
} = {
  module type T = {
    type props = {}
    let make: React.component<props>
  }

  type import = promise<{"make": option<React.component<unit>>}>

  exception ImportError(string)

  @module("solid-js")
  external lazy_: (unit => promise<{"default": React.component<unit>}>) => React.component<unit> =
    "lazy"

  let make: (unit => import) => module(T) = func => {
    // let l = lazy_(() => func()->Js.Promise.then_(comp => {
    //     switch comp["make"] {
    //     | Some(m) => Js.Promise.resolve({"default": m})
    //     | _ => Js.Promise.reject(ImportError("Loaded module is not a component"))
    //     }
    //   }, _))
    let l = lazy_(async () => {
      let comp = await func()
      switch comp["make"] {
      | Some(m) => {"default": m}
      | _ => raise(ImportError("Loaded module is not a component"))
      }
    })

    module Return = {
      type props = {}
      let make: React.component<props> = Obj.magic(l)
    }

    module(Return)
  }
}

@val
external import_: string => Lazy.import = "import"

let lazy_ = Lazy.make

@module("solid-js")
external createUniqueId: unit => string = "createUniqueId"

type deferred<'equals> = {
  equals?: 'equals,
  timeoutMs?: int,
}
@module("solid-js")
external createDeferred: (
  unit => 'value,
  ~options: @unwrap
  [
    | #bool(deferred<bool>)
    | #fn(deferred<('value, 'value) => bool>)
  ]=?,
  unit,
) => accessor<'value> = "createDeferred"

@module("solid-js")
external createRenderEffect: ('value => 'value, ~value: 'value=?, unit) => unit =
  "createRenderEffect"

@module("solid-js")
external createComputed: ('value => 'value, ~value: 'value=?, unit) => unit = "createComputed"

type reaction = thunk<unit> => unit
@module("solid-js")
external createReaction: (unit => unit) => reaction = "createReaction"

@module("solid-js")
external createSelector: (unit => 'source, ~fn: ('other, 'source) => bool=?, unit, 'other) => bool =
  "createSelector"

@module("solid-js/web")
external render: (unit => React.element, Dom.element, unit) => unit = "render"

@module("solid-js/web")
external hydrate: (unit => React.element, Dom.element, unit) => unit = "hydrate"

type renderOptions = {
  nonce?: string,
  renderId?: string,
  timeoutMs?: int,
}

@module("solid-js/web")
external renderToString: (unit => React.element) => string = "renderToString"
@module("solid-js/web")
external renderToStringWith: (unit => React.element, ~options: renderOptions) => string =
  "renderToString"

@module("solid-js/web")
external renderToStringAsync: (unit => React.element) => promise<string> = "renderToStringAsync"
@module("solid-js/web")
external renderToStringAsyncWith: (
  unit => React.element,
  ~options: renderOptions,
) => promise<string> = "renderToStringAsync"

// TODO: Add: "pipeTo" to "renderToStream"
type streamOptions = {
  nonce?: string,
  renderId?: string,
  onCompleteShell?: unit => unit,
  onCompleteAll?: unit => unit,
}
type writable = {write: string => unit}
type streamReturn = {pipe: writable => unit}
@module("solid-js/web")
external renderToStream: (unit => React.element) => streamReturn = "renderToStream"
@module("solid-js/web")
external renderToStreamWith: (unit => React.element, ~options: streamOptions) => streamReturn =
  "renderToStream"

@module("solid-js/web") @val external isServer: bool = "isServer"

@module("solid-js") @val external dev: bool = "DEV"

type hydrateOptions = {nonce?: string, eventNames?: array<string>}
@module("solid-js/web")
external generateHydrationScript: unit => string = "generateHydrationScript"
@module("solid-js/web")
external generateHydrationScriptWith: (~options: hydrateOptions) => string =
  "generateHydrationScript"

module HydrationScript = {
  type props = {nonce?: string, eventNames?: array<string>}
  @module("solid-js/web")
  external make: props => React.element = "HydrationScript"
}

module For = {
  @module("solid-js") @react.component
  external make: (
    ~each: array<'item>,
    ~fallback: React.element=?,
    ~children: ('item, unit => int) => React.element,
    unit,
  ) => React.element = "For"
}

module Show = {
  module Option = {
    @module("solid-js") @react.component
    external make: (
      ~\"when": option<'obj>,
      ~fallback: React.element=?,
      ~children: 'obj => React.element,
      unit,
    ) => React.element = "Show"
  }

  module Bool = {
    @module("solid-js") @react.component
    external make: (
      ~\"when": bool,
      ~fallback: React.element=?,
      ~children: React.element,
      unit,
    ) => React.element = "Show"
  }
}

module Index = {
  @module("solid-js") @react.component
  external make: (
    ~each: array<'item>,
    ~fallback: React.element=?,
    ~children: (unit => 'item, int) => React.element,
    unit,
  ) => React.element = "Index"
}

module Switch = {
  @module("solid-js") @react.component
  external make: (~fallback: React.element=?, ~children: React.element, unit) => React.element =
    "Switch"
}

module Match = {
  module Option = {
    @module("solid-js") @react.component
    external make: (
      ~\"when": option<'obj>,
      ~children: 'obj => React.element,
      unit,
    ) => React.element = "Match"
  }

  module Bool = {
    @module("solid-js") @react.component
    external make: (~\"when": bool, ~children: React.element, unit) => React.element = "Match"
  }
}

// TODO: Add simple form with "fallback: JSX.Element" too
module ErrorBoundary = {
  @module("solid-js") @react.component
  external make: (
    ~fallback: ('error, unit => unit) => React.element,
    ~children: React.element,
    unit,
  ) => React.element = "ErrorBoundary"
}

module Suspense = {
  @module("solid-js") @react.component
  external make: (~fallback: React.element, ~children: React.element, unit) => React.element =
    "Suspense"
}

module SuspenseList = {
  @module("solid-js") @react.component
  external make: (
    ~children: React.element,
    ~revealOrder: [#forwards | #backwards | #together],
    ~tail: [#collapsed | #hidden]=?,
    unit,
  ) => React.element = "SuspenseList"
}

// TODO: Add "Dynamic"

module Portal = {
  @module("solid-js") @react.component
  external make: (
    ~mount: Dom.element=?,
    ~useShadow: bool=?,
    ~isSVG: bool=?,
    ~children: React.element,
    unit,
  ) => React.element = "Portal"
}

// TODO: Add custom directives
