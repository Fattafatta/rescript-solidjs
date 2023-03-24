open Vitest
open SolidTestingLibrary

test("event as func", t => {
  t->assertions(2)

  module EventFunc = {
    @react.component
    let make = () => {
      let (get, set) = Solid.createSignal(1, ())

      <>
        <div> {get()->Belt.Int.toString->React.string} </div>
        <button onClick={_ => set(prev => prev + 1)}> {"click"->React.string} </button>
      </>
    }
  }
  render(_ => <EventFunc />)

  screen->getByText("1")->expect->toBeInTheDocument
  fireEvent->click(screen->getByText("click"))
  screen->getByText("2")->expect->toBeInTheDocument
})

test("event as tuple", t => {
  t->assertions(2)

  module EventTuple = {
    @react.component
    let make = () => {
      let (get, set) = Solid.createSignal(1, ())

      <>
        <div> {get()->Belt.Int.toString->React.string} </div>
        <button onClick={Solid.Event.asTuple((val => set(p => p + val), 1))}>
          {"click"->React.string}
        </button>
      </>
    }
  }
  render(_ => <EventTuple />)

  screen->getByText("1")->expect->toBeInTheDocument
  fireEvent->click(screen->getByText("click"))
  screen->getByText("2")->expect->toBeInTheDocument
})
