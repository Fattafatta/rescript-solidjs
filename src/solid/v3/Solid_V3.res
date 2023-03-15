type accessor<'value> = unit => 'value
type setter<'value> = ('value => 'value) => unit
type signal<'value> = (accessor<'value>, setter<'value>)
type thunk<'m> = unit => 'm
type unitToUnit = unit => unit
type boolOpt = {equals: bool}
type comparatorOpt<'a> = {equals: ('a, 'a) => bool}

type reactive<'r> = 'r
external track: (unit => 'reactive) => reactive<'reactive> = "%identity"

@module("../../react/hyper.js") @variadic
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

module Resource = {
  type info<'value> = {value: option<'value>, refetching: bool}
  type fetchData<'source, 'value> = ('source, info<'value>) => Js.Promise.t<'value>

  type properties<'value> = {
    mutate: option<'value> => option<'value>,
    refetch: unit => Js.Promise.t<'value>,
  }

  type options<'value> = {initialValue: 'value}

  @module("solid-js")
  external make: (
    ~source: accessor<'source>=?,
    fetchData<'source, 'value>,
    ~options: options<'value>=?,
    unit,
  ) => (accessor<option<'value>>, properties<'value>) = "createResource"

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
type onOption = {defer: bool}
@module("solid-js")
external on: (
  array<accessor<'value>>,
  ('value, 'value, option<'return>) => 'return,
  ~options: onOption=?,
  unit,
) => onReturn<'return> = "on"

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
external useTransition: unit => (unit => bool, (unit, unit) => Js.Promise.t<unit>) = "useTransition"

@module("solid-js")
external startTransition: (unit => unit) => Js.Promise.t<unit> = "startTransition"

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
  type props<'value> = {value: 'value, children: React.element}
  type t<'value> = {
    id: Js.Types.symbol,
    @as("Provider") provider: React.component<props<'value>>,
    defaultValue: option<'value>,
  }
  @module("solid-js")
  external make: 'value => t<'value> = "createContext"

  @module("solid-js")
  external useContext: t<'value> => 'value = "useContext"
}

type provider<'value> = {"value": 'value, "children": React.element}
type context<'value> = {
  id: Js.Types.symbol,
  @as("Provider") provider: React.component<provider<'value>>,
  defaultValue: option<'value>,
}

@module("solid-js")
external createContext: 'value => context<'value> = "createContext"

@module("solid-js")
external useContext: context<'value> => 'value = "useContext"

type reactelement
type children<'a> = React.element
type resolved = unit => children<reactelement>
@module("solid-js")
external children: (unit => React.element) => resolved = "children"

module Lazy: {
  module type T = {
    let make: React.component<unit>
    let makeProps: unit => unit
  }
  type dynamicImport = Js.Promise.t<{"make": option<React.component<unit>>}>
  let make: (unit => dynamicImport) => module(T)
} = {
  module type T = {
    let make: React.component<unit>
    let makeProps: unit => unit
  }
  type dynamicImport = Js.Promise.t<{"make": option<React.component<unit>>}>

  exception ImportError(string)

  @module("solid-js")
  external lazy_: (unit => Js.Promise.t<{"default": React.component<unit>}>) => React.component<
    unit,
  > = "lazy"

  let make: (unit => dynamicImport) => module(T) = func => {
    let l = lazy_(() => func()->Js.Promise.then_(comp => {
        switch comp["make"] {
        | Some(m) => Js.Promise.resolve({"default": m})
        | _ => Js.Promise.reject(ImportError("Loaded module is not a component"))
        }
      }, _))

    module Return = {
      let make = l
      let makeProps = () => ()
    }

    module(Return)
  }
}

@val
external import_: string => Lazy.dynamicImport = "import"

@module("solid-js")
external createUniqueId: unit => string = "createUniqueId"

// TODO: Add option: "timeoutMs"
@module("solid-js")
external createDeferred: (
  unit => 'value,
  ~options: @unwrap
  [
    | #bool(boolOpt)
    | #fn(comparatorOpt<'a>)
  ]=?,
  unit,
) => accessor<'value> = "createDeferred"

@module("solid-js")
external createRenderEffect: ('value => 'value, ~value: 'value=?, unit) => unit =
  "createRenderEffect"

@module("solid-js")
external createComputed: ('value => 'value, ~value: 'value=?, unit) => unit = "createComputed"

@module("solid-js")
external createReaction: (unit => unit, unit => unit) => unit = "createReaction"

@module("solid-js")
external createSelector: (unit => 'source, ~fn: ('other, 'source) => bool=?, unit, 'other) => bool =
  "createSelector"

@module("solid-js/web")
external render: (unit => React.element, Dom.element, unit) => unit = "render"

@module("solid-js/web")
external hydrate: (unit => React.element, Dom.element, unit) => unit = "hydrate"

@module("solid-js/web")
external renderToString: (unit => React.element) => string = "renderToString"
@module("solid-js/web")
external renderToStringAsync: (unit => React.element) => Js.Promise.t<string> =
  "renderToStringAsync"

type writable = {write: string => unit}
type streamReturn = {pipe: writable => unit}
@module("solid-js/web")
external renderToStream: (unit => React.element) => streamReturn = "renderToStream"

@module("solid-js/web") @val external isServer: bool = "isServer"

@module("solid-js") @val external dev: bool = "DEV"

type hydrateOptions = {eventNames: array<string>}
@module("solid-js/web")
external generateHydrationScript: (~options: hydrateOptions) => string = "generateHydrationScript"

@module("solid-js/web")
external generateHydrationScriptWith: (~options: hydrateOptions) => string =
  "generateHydrationScript"

module HydrationScript = {
  type props = {eventNames: array<string>}
  @module("solid-js/web")
  external make: props => React.element = "HydrationScript"
}

module For = {
  @module("solid-js") @react.component
  external make: (
    ~each: array<'component>,
    ~fallback: React.element=?,
    ~children: ('component, unit => int) => React.element,
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
    ~each: array<'component>,
    ~fallback: React.element=?,
    ~children: (unit => 'component, int) => React.element,
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

// HyperScript conrol flow
module H = {
  module For = {
    external toElement: (unit => array<React.element>) => React.element = "%identity"

    @react.component @deprecated
    let make = (
      ~each: unit => array<'component>,
      ~children: ('component, unit => int) => React.element,
      ~fallback: option<React.element>=?,
    ) => {
      switch fallback {
      | Some(x) =>
        mapArrayi(each, children, ~options={fallback: () => x}, ())->createMemoUnit()->toElement
      | None => mapArrayi(each, children, ())->createMemoUnit()->toElement
      }
    }
  }
  module Show = {
    external toElement: (unit => React.element) => React.element = "%identity"

    module Bool = {
      @react.component @deprecated
      let make = (
        ~\"when": unit => bool,
        ~fallback: option<React.element>=?,
        ~children: React.element,
      ) => {
        let condition = createMemoUnit(\"when", ())

        createMemoUnit(() => {
          let c = condition()
          switch (c, fallback) {
          | (true, _) => children
          | (false, Some(f)) => f
          | (false, None) => React.null
          }
        }, ())->toElement
      }
    }

    module Option = {
      @react.component @deprecated
      let make = (
        ~\"when": unit => option<'obj>,
        ~fallback: option<React.element>=?,
        ~children: 'obj => React.element,
      ) => {
        let eq: (option<'obj>, option<'obj>) => bool = (a, b) => {
          switch (a, b) {
          | (Some(_), Some(_)) => true
          | _ => false
          }
        }
        let condition = createMemoUnit(\"when", ~options=#fn({equals: eq}), ())
        createMemoUnit(() => {
          let c = condition()
          switch (c, fallback) {
          | (Some(o), _) => untrack(() => children(o))
          | (None, Some(f)) => f
          | (None, None) => React.null
          }
        }, ())->toElement
      }
    }
  }

  module Index = {
    @react.component @deprecated
    let make = (
      ~each: unit => array<'component>,
      ~children: (accessor<'component>, int) => React.element,
      ~fallback: option<React.element>=?,
    ) => {
      switch fallback {
      | Some(x) =>
        indexArray(each, children, ~options={fallback: () => x}, ())
        ->createMemoUnit()
        ->For.toElement
      | None => indexArray(each, children, ())->createMemoUnit()->For.toElement
      }
    }
  }
}
