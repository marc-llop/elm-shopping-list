module Ui.Button exposing (button, docs)

import Css exposing (..)
import Css.Transitions exposing (easeOut, transition)
import DesignSystem.Colors exposing (..)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html
import Html.Styled exposing (Html, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)


buttonStyles : List Style
buttonStyles =
    [ displayFlex
    , minWidth (px 100)
    , padding2 (px 10) (px 20)
    , justifyContent center
    , fontSize (rem 1.2)
    , color (hex neutral300)
    , backgroundColor transparent
    , border3 (px 2) solid (hex neutral100)
    , borderRadius (px 10)
    , property "box-shadow" (shadow 10 neutral300 ++ ", " ++ insetShadow 10 neutral300)
    , cursor pointer
    , buttonTransition 200
    , hover
        [ borderColor (hex accentGreen100)
        , color (hex accentGreen100)
        , property "text-shadow" greenBlueShadow
        , property "box-shadow" greenBlueInsetShadow
        , buttonTransition 50
        , focus [ outline3 (px 3) solid (hex accentGreen100) ]
        ]
    , active
        [ borderColor (hex white)
        , color (hex white)
        , property "text-shadow" whiteShadow
        , property "box-shadow" whiteInsetShadow
        , focus [ outline none ]
        ]
    , focus
        [ outline3 (px 3) solid (hex neutral300)
        ]
    ]


buttonTransition duration =
    transition
        [ Css.Transitions.color3 duration 0 easeOut
        , Css.Transitions.boxShadow3 duration 0 easeOut
        , Css.Transitions.border3 duration 0 easeOut
        , Css.Transitions.textShadow3 50 0 easeOut
        ]


shadow : Int -> String -> String
shadow size color =
    "0 0 " ++ String.fromInt size ++ "px #" ++ color


insetShadow : Int -> String -> String
insetShadow size color =
    "inset " ++ shadow size color


greenBlueShadow =
    [ shadow 10 accentGreen500
    , shadow 15 accentBlue650
    , shadow 20 accentBlue650
    ]
        |> String.join ", "


greenBlueInsetShadow =
    [ shadow 10 accentGreen500
    , shadow 15 accentBlue650
    , shadow 20 accentBlue650
    , insetShadow 10 accentGreen500
    , insetShadow 15 accentBlue650
    , insetShadow 20 accentBlue650
    ]
        |> String.join ", "


whiteShadow =
    [ shadow 10 backgroundPurple100
    , shadow 15 accentBlue150
    ]
        |> String.join ", "


whiteInsetShadow =
    [ shadow 10 backgroundPurple100
    , shadow 15 accentBlue150
    , insetShadow 10 backgroundPurple100
    , insetShadow 15 accentBlue150
    ]
        |> String.join ", "


button : { label : String, onUse : msg, customStyle : List Style } -> Html msg
button { label, onUse, customStyle } =
    Html.Styled.button
        [ css (List.concat [ buttonStyles, customStyle ]), onClick onUse ]
        [ span [] [ text label ] ]


docs : Chapter x
docs =
    let
        props =
            { label = "Accept"
            , onUse = logAction "Button clicked"
            , customStyle = []
            }

        -- withMargin = styled [ ]
    in
    chapter "Buttons"
        |> renderComponentList
            [ ( "Default", button props )
            , ( "With other text", button { props | label = "Hi" } )
            ]
