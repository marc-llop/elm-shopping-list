module Utils exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (classList)


flip fn =
    \a b -> fn b a


classStrList : List String -> Attribute msg
classStrList =
    List.map (flip Tuple.pair True) >> classList
