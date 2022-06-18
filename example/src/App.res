open Solid
open Js

type todo = {id: string, text: string, completed: bool}

@get external getInputValue: Dom.element => string = "value"
@set external setInputValue: (Dom.element, string) => unit = "value"

@react.component
let make = () => {
  let (todos, setTodos) = Store.make([])
  let inputRef = ref(Nullable.null)

  let addTodo = r => {
    r.contents
    ->Nullable.toOption
    ->Belt.Option.map(inputEl => {
      switch inputEl->getInputValue->String2.trim {
      | "" => ()
      | text => {
          setTodos(td => td->Array2.concat([{id: createUniqueId(), text: text, completed: false}]))
          inputEl->setInputValue("")
        }
      }
    })
    ->ignore
  }

  let toggleTodo = id => {
    setTodos(td =>
      td->Array2.map(t =>
        switch t.id == id {
        | true => {id: t.id, text: t.text, completed: !t.completed}
        | false => t
        }
      )
    )
  }
  <>
    <div>
      <input placeholder="new todo here " ref={el => {inputRef := el}} />
      <button onClick={Event.asArray((addTodo, inputRef))}> {"Add Todo"->React.string} </button>
    </div>
    <For each={todos} fallback={"Nothing to do."->React.string}>
      {(todo, _) => {
        let {id, text, completed} = todo

        let style = switch completed {
        | true => "text-decoration: line-through"
        | false => "text-decoration: none"
        }

        <div onClick={Solid.Event.asArray((toggleTodo, id))}>
          <input type_="checkbox" checked={completed} />
          <span style classList={makeClassList([("completed", completed), ("open", !completed)])}>
            {text->React.string}
          </span>
        </div>
      }}
    </For>
  </>
}
