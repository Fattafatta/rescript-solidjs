Solid.render(
  () => <Counter.Provider count={3}> <App /> </Counter.Provider>,
  Document.querySelector("#root")->Belt.Option.getExn,
  (),
)
