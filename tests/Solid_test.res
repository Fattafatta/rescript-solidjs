open Vitest
open SolidTestingLibrary

describe("Solid reactivity", () => {
  test("createSignal", t => {
    t->assertions(2)
    let (get, set) = Solid.createSignal(1, ())

    expect(get())->toBe(1)
    set(prev => prev + 1)
    expect(get())->toBe(2)
  })

  test("createSignal - with comparator options", t => {
    t->assertions(3)
    let (get, set) = Solid.createSignal(1, ~options=#fn({equals: (a, b) => a > b}), ())

    expect(get())->toBe(1)
    set(prev => prev + 1)
    expect(get())->toBe(2)
    set(prev => prev - 1)
    expect(get())->toBe(2)
  })

  test("createSignal - with bool options", t => {
    t->assertions(1)
    let (get, _) = Solid.createSignal(1, ~options=#bool({equals: false}), ())

    expect(get())->toBe(1)
  })

  test("createEffect", t => {
    t->assertions(2)

    let ref = ref("old")
    renderHook(
      _ => {
        Solid.createEffect(
          _ => {
            ref := "new"
          },
          (),
        )
        expect(ref.contents)->toBe("old")
      },
    )->ignore
    expect(ref.contents)->toBe("new")
  })

  test("createEffect - with initial value", t => {
    t->assertions(2)

    let ref = ref("old")
    renderHook(
      _ => {
        Solid.createEffect(
          val => {
            ref := val
            val
          },
          ~value="new",
          (),
        )
        expect(ref.contents)->toBe("old")
      },
    )->ignore
    expect(ref.contents)->toBe("new")
  })

  test("createMemoUnit", t => {
    t->assertions(3)
    Solid.createRoot(
      _ => {
        let memo = Solid.createMemoUnit(_ => "memo", ())
        expect(memo())->toBe("memo")

        let (get, set) = Solid.createSignal(1, ())
        let value = Solid.createMemoUnit(_ => get(), ())
        expect(value())->toBe(1)
        set(prev => prev + 1)
        expect(value())->toBe(2)
      },
    )
  })

  test("createMemo", t => {
    t->assertions(2)
    Solid.createRoot(
      _ => {
        let (get, set) = Solid.createSignal(1, ())
        let sum = Solid.createMemo(prev => get() + prev, ~value=1, ())
        expect(sum())->toBe(2)
        set(prev => prev + 1)
        expect(sum())->toBe(4)
      },
    )
  })

  testAsync("Resource.make", async t => {
    t->assertions(3)

    let fetch = (text, _) => {
      Js.Promise2.make(
        (~resolve, ~reject as _) => {
          let content = text ++ "text"
          Js.Global.setTimeout(() => resolve(. content), 5)->ignore
        },
      )
    }

    let {result: (data, _)} = renderHook(() => Solid.Resource.make(~source=() => "my ", fetch, ()))

    expect(Solid.Resource.loading(data))->toBe(true)
    expect(Belt.Option.getWithDefault(data(), "default"))->toBe("default")

    await waitForWith(
      () => expect(Belt.Option.getExn(data()))->toBe("my text"),
      ~options={timeout: 20, interval: 10},
      (),
    )
  })

  testAsync("Resource.makeWithInitial", async t => {
    t->assertions(4)

    let fetch = (_, _) => {
      Js.Promise2.make(
        (~resolve, ~reject as _) => {
          // let content = text ++ "text"
          Js.Global.setTimeout(() => resolve(. "text"), 5)->ignore
        },
      )
    }

    let {result: (data, {refetch})} = renderHook(
      () => Solid.Resource.makeWithInitial(fetch, ~options={initialValue: "init"}, ()),
    )

    expect(data())->toBe("init")
    refetch()->ignore
    expect(Solid.Resource.loading(data))->toBe(true)

    await waitForWith(() => expect(data())->toBe("text"), ~options={timeout: 20, interval: 10}, ())
  })

  testAsync("useTransition", async t => {
    t->assertions(1)
    let (tab, setTab) = Solid.createSignal(0, ())
    let (_, start) = Solid.useTransition()
    await start(_ => setTab(_ => 1))

    expect(tab())->toBe(1)
  })

  testAsync("startTransition", async t => {
    t->assertions(1)
    let (tab, setTab) = Solid.createSignal(0, ())
    await Solid.startTransition(_ => setTab(_ => 1))

    expect(tab())->toBe(1)
  })

  test("creatUniqueId", t => {
    t->assertions(1)
    let id = Solid.createUniqueId()
    expect(id)->toBeTruthy
  })
})

type props = {
  a?: string,
  b?: string,
}

type split = {
  c: string,
  d: string,
}
type splitA = {c: string}
type splitB = {d: string}
type otherC = {}

describe("Solid utilities", () => {
  test("untrack", t => {
    t->assertions(2)
    let (get, set) = Solid.createSignal(1, ())
    let untracked = Solid.untrack(() => get())

    expect(untracked)->toBe(1)
    set(prev => prev + 1)
    expect(untracked)->toBe(1)
  })

  test("batch", t => {
    t->assertions(2)
    let (get, set) = Solid.createSignal(1, ())

    Solid.batch(
      _ => {
        expect(get())->toBe(1)
        set(prev => prev + 1)
        expect(get())->toBe(2)
      },
    )
  })

  test("on", t => {
    t->assertions(1)
    let (a, _) = Solid.createSignal(1, ())
    let (b, setB) = Solid.createSignal(1, ())
    renderHook(
      () => {
        let fn = Solid.on(a, (v, _, _) => expect(v + b())->toBe(2), ())
        Solid.createEffect(fn, ())
      },
    )->ignore

    setB(prev => prev + 1)
  })

  test("on2", t => {
    t->assertions(1)
    let (a1, _) = Solid.createSignal(1, ())
    let (a2, _) = Solid.createSignal(1, ())
    let (b, setB) = Solid.createSignal(1, ())

    renderHook(
      () => {
        let fn = Solid.on2((a1, a2), ((v1, v2), _, _) => expect(v1 + v2 + b())->toBe(3), ())
        Solid.createEffect(fn, ())
      },
    )->ignore

    setB(prev => prev + 1)
  })

  test("mergeProps", t => {
    t->assertions(2)
    let props = Solid.mergeProps({a: "text"}, {b: "text"})

    expect(Belt.Option.getUnsafe(props.a))->toBe("text")
    expect(Belt.Option.getUnsafe(props.b))->toBe("text")
  })

  test("mergePropsVariadic", t => {
    t->assertions(2)
    let props = Solid.mergePropsVariadic([{a: "text"}, {b: "text"}, {a: "other"}])

    expect(Belt.Option.getUnsafe(props.a))->toBe("other")
    expect(Belt.Option.getUnsafe(props.b))->toBe("text")
  })

  test("splitProps", t => {
    t->assertions(8)
    let (propsC, otherC) = Solid.splitProps({c: "a", d: "b"}, ["c"])
    let (propsD, otherD) = Solid.splitProps({c: "a", d: "b"}, ["d"])

    expect(propsC.c)->toBe("a")
    expect(propsC.d)->toBeUndefined
    expect(propsD.d)->toBe("b")
    expect(propsD.c)->toBeUndefined
    expect(otherC.d)->toBe("b")
    expect(otherD.c)->toBe("a")

    let (propsE, otherE) = Solid.splitProps({c: "a", d: "b"}, ["c", "d"])

    expect(propsE)->toMatchObject({c: "a", d: "b"})
    expect(otherE)->toMatchObject(({}: otherC))
  })

  test("splitProps2", t => {
    t->assertions(5)
    let (propsC, propsD, other) = Solid.splitProps2({c: "a", d: "b"}, ["c"], ["d"])

    expect(propsC.c)->toBe("a")
    expect(propsC.d)->toBeUndefined
    expect(propsD.d)->toBe("b")
    expect(propsD.c)->toBeUndefined
    expect(other)->toMatchObject(({}: otherC))
  })
})

describe("Solid component apis", () => {
  module Children = {
    @react.component
    let make = (~children) => {
      let resolved = Solid.children(() => children)
      <div>
        {resolved()}
        {resolved()}
      </div>
    }
  }
  test("children", t => {
    t->assertions(1)
    render(_ => <Children> {"text"->React.string} </Children>)

    screen->getByText("texttext")->expect->toBeInTheDocument
  })

  test("createContext", t => {
    t->assertions(1)
    let context = Solid.Context.make("text")
    let res = Solid.Context.useContext(context)
    expect(res)->toBe("text")
  })

  test("createContext - without arguments defaults to undefined", t => {
    t->assertions(1)
    let context = Solid.Context.make()
    let res = Solid.Context.useContext(context)
    expect(res)->toBeUndefined
  })

  test("createContext - Provider", t => {
    t->assertions(1)

    let context = Solid.Context.make((() => "", _ => ()))
    let useText = () => Solid.Context.useContext(context)

    let module(Provider) = context.provider

    module TextProvider = {
      @react.component
      let make = (~children) => {
        let sig = Solid.createSignal("?", ())

        <Provider value={sig}> {children} </Provider>
      }
    }
    module Nested = {
      @react.component
      let make = () => {
        let (get, set) = useText()
        set(p => p ++ "!")
        <div> {get()->React.string} </div>
      }
    }
    render(
      _ => {
        <TextProvider>
          <Nested />
        </TextProvider>
      },
    )

    screen->getByText("?!")->expect->toBeInTheDocument
  })

  testAsync("Lazy.make", async t => {
    t->assertions(2)
    let module(Lazy) = Solid.Lazy.make(() => Solid.import_("./Lazy.bs.js"))

    render(
      _ =>
        <Solid.Suspense fallback={<div> {"waiting..."->React.string} </div>}>
          <Lazy />
        </Solid.Suspense>,
    )

    screen->getByText("waiting...")->expect->toBeInTheDocument

    await waitForWith(
      () => screen->getByText("lazy")->expect->toBeInTheDocument,
      ~options={timeout: 20, interval: 10},
      (),
    )
  })
})

describe("Solid control flow", () => {
  module ControlFlow = {
    @react.component
    let make = () => {
      <div>
        <Solid.For each={["a", "b", "c"]} fallback={<div> {"Loading..."->React.string} </div>}>
          {(item, _) => <div> {item->React.string} </div>}
        </Solid.For>
        <Solid.Show.Option
          \"when"={Some("showoption")} fallback={<div> {"Loading..."->React.string} </div>}>
          {item => <div> {item->React.string} </div>}
        </Solid.Show.Option>
        <Solid.Show.Bool \"when"={1 > 0} fallback={<div> {"Loading..."->React.string} </div>}>
          <div> {"showbool"->React.string} </div>
        </Solid.Show.Bool>
        <Solid.Index each={["d", "e", "f"]} fallback={<div> {"Loading..."->React.string} </div>}>
          {(item, _) => <div> {item()->React.string} </div>}
        </Solid.Index>
        <Solid.Switch fallback={"Fallback"->React.string}>
          <Solid.Match.Bool \"when"={false}> {"switchbool"->React.string} </Solid.Match.Bool>
          <Solid.Match.Option \"when"={Some("switchoption")}>
            {text => <div> {text->React.string} </div>}
          </Solid.Match.Option>
        </Solid.Switch>
      </div>
    }
  }

  test("for", t => {
    t->assertions(3)
    render(_ => <ControlFlow />)

    screen->getByText("a")->expect->toBeInTheDocument
    screen->getByText("b")->expect->toBeInTheDocument
    screen->getByText("c")->expect->toBeInTheDocument
  })

  test("show", t => {
    t->assertions(2)
    render(_ => <ControlFlow />)

    screen->getByText("showoption")->expect->toBeInTheDocument
    screen->getByText("showbool")->expect->toBeInTheDocument
  })

  test("index", t => {
    t->assertions(3)
    render(_ => <ControlFlow />)

    screen->getByText("d")->expect->toBeInTheDocument
    screen->getByText("e")->expect->toBeInTheDocument
    screen->getByText("f")->expect->toBeInTheDocument
  })

  test("switch", t => {
    t->assertions(2)
    render(_ => <ControlFlow />)

    screen->queryByText("switchbool")->expect->_not->toBeInTheDocument
    screen->getByText("switchoption")->expect->toBeInTheDocument
  })

  testAsync("suspense", async t => {
    t->assertions(2)

    let fetch = (_, _) => {
      Js.Promise2.make(
        (~resolve, ~reject as _) => {
          Js.Global.setTimeout(() => resolve(. "text"), 5)->ignore
        },
      )
    }

    module Fetch = {
      @react.component
      let make = () => {
        let (data, _) = Solid.Resource.make(~source=() => "", fetch, ())
        <div> {data()->Obj.magic->React.string} </div>
      }
    }

    render(
      _ => {
        <Solid.Suspense fallback={<div> {"loading"->React.string} </div>}>
          <Fetch />
        </Solid.Suspense>
      },
    )

    screen->getByText("loading")->expect->toBeInTheDocument

    await waitForWith(
      () => screen->getByText("text")->expect->toBeInTheDocument,
      ~options={timeout: 20, interval: 10},
      (),
    )
  })
})

describe("Solid jsx attributes", () => {
  test("classList", t => {
    t->assertions(1)
    let cl = Solid.makeClassList([("c1", true), ("c2", false)])

    expect(Obj.magic(cl))->toMatchObject({
      "c1": true,
      "c2": false,
    })
  })

  test("style", t => {
    t->assertions(1)
    render(_ => <div style={"display: none"}> {"text"->React.string} </div>)

    screen->queryByText("text")->expect->_not->toBeVisible
  })
})

type state = {
  a?: string,
  b?: int,
  c: bool,
}

describe("Solid store", () => {
  test("make & update", t => {
    t->assertions(5)

    let (state, setState) = Solid.Store.make(({c: false}: state))
    expect(state.c)->toBe(false)
    setState(_ => {c: true})
    expect(state.c)->toBe(true)
    setState(_ => {b: 1, c: false})
    expect(state.c)->toBe(false)
    expect(Belt.Option.getUnsafe(state.b))->toBe(1)
    expect(state.a)->toBeUndefined
  })

  test("unwrap", t => {
    t->assertions(1)
    let (state, _) = Solid.Store.make(({c: false}: state))
    let unwrapped = Solid.Store.unwrap(state)
    expect(unwrapped.c)->toBe(false)
  })
})

describe("Solid lifecycles", () => {
  test("onMount", t => {
    t->assertions(1)

    module Mount = {
      @react.component
      let make = () => {
        let (get, set) = Solid.createSignal(0, ())

        Solid.onMount(
          _ => {
            set(_ => 1)
          },
        )

        <div> {get()->React.int} </div>
      }
    }
    render(_ => <Mount />)

    screen->queryByText("1")->expect->toBeInTheDocument
  })

  testAsync("onCleanup", async t => {
    t->assertions(3)

    let ref = ref("old")

    let (get, set) = Solid.createSignal(0, ())
    Solid.createRoot(
      _ => {
        Solid.createEffect(
          _ => {
            get()->ignore
            Solid.onCleanup(_ => ref := "new")
          },
          (),
        )

        Js.Global.setTimeout(
          () => {
            expect(ref.contents)->toBe("old")
            set(_ => 1)
          },
          0,
        )->ignore
      },
    )
    await waitForWith(
      () => expect(ref.contents)->toBe("new"),
      ~options={timeout: 20, interval: 10},
      (),
    )
  })
})

describe("Solid secondary primitives", () => {
  testAsync("createDeferred", async t => {
    t->assertions(3)
    await Solid.createRoot(
      async _ => {
        let (get, set) = Solid.createSignal(1, ())
        let deferred = Solid.createDeferred(get, ~options=#bool({timeoutMs: 5, equals: false}), ())

        expect(deferred())->toBe(1)
        set(p => p + 1)
        await waitForWith(
          () => expect(deferred())->toBe(2),
          ~options={timeout: 20, interval: 10},
          (),
        )
      },
    )
  })

  test("createRenderEffect", t => {
    t->assertions(1)

    let ref = ref("old")
    Solid.createRoot(
      _ => {
        Solid.createRenderEffect(
          _ => {
            ref := "new"
          },
          (),
        )
        expect(ref.contents)->toBe("new")
      },
    )
  })

  test("createComputed", t => {
    t->assertions(1)

    let ref = ref("init")

    Solid.createRoot(
      _ => {
        let (get, set) = Solid.createSignal("", ())
        Solid.createComputed(
          v => {
            ref := v ++ get()
            ref.contents
          },
          ~value="hello",
          (),
        )
        set(p => p ++ "!")
        expect(ref.contents)->toBe("hello!")
      },
    )
  })

  testAsync("createReaction", async t => {
    t->assertions(3)

    let ref = ref("init")

    await Solid.createRoot(
      async _ => {
        let (get, set) = Solid.createSignal("", ())
        let track = Solid.createReaction(_ => ref := "!")
        expect(ref.contents)->toBe("init")

        Js.Global.setTimeout(
          _ => {
            track(() => get()->ignore)
            set(p => p ++ "!")
          },
          0,
        )->ignore
      },
    )
    await waitForWith(
      () => expect(ref.contents)->toBe("!"),
      ~options={timeout: 20, interval: 10},
      (),
    )
  })
})

type console

@val external console: console = "console"
@get external getError: console => 'mock = "error"
@set external setError: (console, 'any) => unit = "error"

let consoleRef: ref<string => unit> = ref(Js.Console.error)
let mockConsoleError = ViPlus.fn()

describe("Solid rendering", () => {
  beforeEach(_ => {
    setError(console, mockConsoleError)
    mockConsoleError.mockReset()
  })

  afterEach(_ => {
    setError(console, consoleRef.contents)
  })

  test("renderToString - does not work in browser", t => {
    t->assertions(2)

    Solid.createRoot(
      _ => {
        let result = Solid.renderToString(() => <div />)

        expect(mockConsoleError.mock.calls[0][0].message)->toContain(
          "renderToString is not supported in the browser, returning undefined",
        )
        expect(result)->toBeUndefined
      },
    )
  })

  test("renderToStream - does not work in browser", t => {
    t->assertions(2)

    Solid.createRoot(
      _ => {
        let result = Solid.renderToStream(() => <div />)

        expect(mockConsoleError.mock.calls[0][0].message)->toContain(
          "renderToStream is not supported in the browser, returning undefined",
        )
        expect(result)->toBeUndefined
      },
    )
  })
})

// getowner + runwithowner
// ErrorBoundary
// ref
