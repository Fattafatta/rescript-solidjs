type t<'e> = 'e => unit
@deprecated("No longer needed. Just pass the function directly: `onClick={event => Js.log(event)}`")
let asFn: ('e => unit) => t<'e>
let asArray: (('data => unit, 'data)) => t<'e>
let asTuple: (('data => unit, 'data)) => t<'e>
