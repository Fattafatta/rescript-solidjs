open Vitest
open SolidTestingLibrary

describe("JsxDom", _ => {
  test("textContent", t => {
    t->assertions(1)
    render(_ => <div textContent="text" />)
    screen->getByText("text")->expect->toBeInTheDocument
  })

  test("class", t => {
    t->assertions(1)
    render(_ => <button class="text" />)
    screen->getByRole("button")->expect->toHaveClass("text")
  })

  test("classList", t => {
    t->assertions(2)
    render(_ => <button classList={Solid.makeClassList([("text", true), ("none", false)])} />)
    screen->getByRole("button")->expect->toHaveClass("text")
    screen->getByRole("button")->expect->not_->toHaveClass("none")
  })
})
