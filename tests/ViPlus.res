type t

type err = {message: string}
type mock = {calls: array<array<err>>}
type mockReturn = {
  mockReset: unit => unit,
  mock: mock,
}

%%private(@module("vitest") @val external vi_obj: t = "vi")

@send external fn: t => mockReturn = "fn"
@inline let fn = () => vi_obj->fn
