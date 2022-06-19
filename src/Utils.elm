module Utils exposing (..)

import Css exposing (..)
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (attribute, css)


flip fn =
    \a b -> fn b a


dataTestId : String -> Attribute msg
dataTestId testId =
    attribute "data-testid" testId



-- Used to showcase translucent items in elm-book


transparencyBackground : { width : Float, height : Float } -> Html msg -> Html msg
transparencyBackground { width, height } component =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , justifyContent center
            , Css.width (px width)
            , Css.height (px height)
            ]
        ]
        [ div
            [ css
                [ Css.property "background" "repeating-conic-gradient(#808080 0% 25%, transparent 0% 50%) 50% / 20px 20px"
                , Css.width (px width)
                , Css.height (px height)
                , position absolute
                , top zero
                ]
            ]
            []
        , component
        ]
