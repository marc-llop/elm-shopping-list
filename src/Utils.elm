module Utils exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (attribute)


flip fn =
    \a b -> fn b a


dataTestId : String -> Attribute msg
dataTestId testId =
    attribute "data-testid" testId
