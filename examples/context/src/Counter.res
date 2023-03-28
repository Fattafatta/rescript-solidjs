open Solid

type count = {count: int}
let context = createContext(({count: 0}, () => (), () => ()))

module Provider = {
  @react.component
  let make = (~children, ~count) => {
    let module(ContextProvider) = context.provider

    let (state, setState) = Store.make({count: count})
    let store = (
      state,
      () => setState(p => {count: p.count + 1}),
      () => setState(p => {count: p.count - 1}),
    )

    <ContextProvider value={store}> {children} </ContextProvider>
  }
}
