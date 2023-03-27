type render = unit => Jsx.element
@module("@solidjs/testing-library")
external render: render => unit = "render"

// render hook
type renderHookResult<'props, 'return> = {
  result: 'return,
  cleanup: unit => unit,
  owner: Solid.owner,
}

type renderHookOption<'props> = {
  initialProps?: 'props,
  wrapper?: React.element,
}

@module("@solidjs/testing-library")
external renderHook: ('props => 'return) => renderHookResult<'props, 'return> = "renderHook"
@module("@solidjs/testing-library")
external renderHookWith: (
  'props => 'result,
  renderHookOption<'props>,
) => renderHookResult<'props, 'return> = "renderHook"

type renderResult
@module("@solidjs/testing-library")
external screen: renderResult = "screen"

@send external getByText: (renderResult, string) => Webapi.Dom.Element.t = "getByText"

@send external queryByText: (renderResult, string) => Webapi.Dom.Element.t = "queryByText"

@send external getByRole: (renderResult, string) => Webapi.Dom.Element.t = "getByRole"

@send
external toBeInTheDocument: Vitest.expected<Webapi.Dom.Element.t> => unit = "toBeInTheDocument"

@send
external toHaveClass: (Vitest.expected<Webapi.Dom.Element.t>, string) => unit = "toHaveClass"

@send
external toBeVisible: Vitest.expected<Webapi.Dom.Element.t> => unit = "toBeVisible"

@send
external toBe: (Vitest.expected<'a>, 'a) => unit = "toBe"

@send
external toContain: (Vitest.expected<'a>, 'a) => unit = "toContain"

@send
external toHaveLength: (Vitest.expected<'a>, int) => unit = "toHaveLength"

@send
external toMatchObject: (Vitest.expected<'a>, 'a) => unit = "toMatchObject"

@send
external toBeUndefined: Vitest.expected<'a> => unit = "toBeUndefined"

@send
external toBeNull: Vitest.expected<'a> => unit = "toBeNull"

@send
external toBeTruthy: Vitest.expected<'a> => unit = "toBeTruthy"

@get
external not_: Vitest.expected<'a> => Vitest.expected<'a> = "not"

type fireEvent

@module("@solidjs/testing-library")
external fireEvent: fireEvent = "fireEvent"

@send external click: (fireEvent, Webapi.Dom.Element.t) => unit = "click"

type waitForOptions = {
  container?: Jsx.element,
  timeout?: int,
  interval?: int,
  //onTimeout?: (error: Error) => Error
  //mutationObserverOptions?: MutationObserverInit
}

@module("@solidjs/testing-library")
external waitFor: Solid.thunk<'t> => promise<'t> = "waitFor"

@module("@solidjs/testing-library")
external waitForWith: (Solid.thunk<'t>, ~options: waitForOptions=?, unit) => promise<'t> = "waitFor"
