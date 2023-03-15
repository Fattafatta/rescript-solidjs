// Handling polymorphic on... signatures
type t<'event> = 'event => unit
external asArray: (('val => unit, 'val)) => t<'event> = "%identity"
external asFn: ('event => unit) => t<'event> = "%identity"
external asTuple: (('val => unit, 'val)) => t<'event> = "%identity"
