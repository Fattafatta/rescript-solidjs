// Handling polymorphic on... signatures
type t<'event>
external asArray: (('val => unit, 'val)) => t<'event> = "%identity"
external asFn: ('e => unit) => t<'event> = "%identity"
