open Solid

module Nested = {
  @react.component
  let make = () => {
    let (count, increment, decrement) = Solid.useContext(Counter.context)
    <>
      <div> {count.count->React.int} </div>
      <button onClick={Event.asArray((increment, ()))}> {"+"->React.string} </button>
      <button onClick={_ => decrement()}> {"-"->React.string} </button>
    </>
  }
}

@react.component
let make = () => {
  <Counter.Provider count={1}>
    <h1> {"Welcome to Counter App"->React.string} </h1>
    <Nested />
  </Counter.Provider>
}
