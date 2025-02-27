type 'a t = < get : 'a ; set : 'a -> unit >

let def default =
  object (self)
    val mutable c = default
    method get = c
    method set v = c <- v
  end
