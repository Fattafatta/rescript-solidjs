@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

@val @scope("document") @return(nullable)
external querySelector: string => option<Dom.element> = "querySelector"
