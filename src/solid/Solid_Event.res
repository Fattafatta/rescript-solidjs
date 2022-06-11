// Polymorphic on... signatures
@unboxed
type rec t<'e> = Any('a): t<'e>
let asFn = (v: 'e => unit) => Any(v)
let asArray = (v: ('data => unit, 'data)) => Any(v)
