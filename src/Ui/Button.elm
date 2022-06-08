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


neutral =
    neutral300


neutralLight =
    neutral100


accentGreenLight =
    accentGreen100


accentGreen =
    accentGreen500


buttonStyles : List Style
buttonStyles =
    [ displayFlex
    , minWidth (px 100)
    , padding2 (px 10) (px 20)
    , justifyContent center
    , fontSize (rem 1.2)
    , color (hex neutral)
    , backgroundColor transparent
    , border3 (px 2) solid (hex neutralLight)
    , borderRadius (px 10)
    , property "box-shadow"
        ("inset 0 0 10px #"
            ++ neutral
            ++ ", 0 0 10px #"
            ++ neutral
        )
    , cursor pointer
    , buttonTransition 200
    , hover
        [ borderColor (hex accentGreenLight)
        , color (hex accentGreenLight)
        , property "text-shadow" greenBlueBlurGradient
        , property "box-shadow" (greenBlueBlurGradient ++ ", " ++ greenBlueInsetBlurGradient)
        , buttonTransition 50
        ]
    ]


buttonTransition duration =
    transition
        [ Css.Transitions.color3 duration 0 easeOut
        , Css.Transitions.boxShadow3 duration 0 easeOut
        , Css.Transitions.border3 duration 0 easeOut
        , Css.Transitions.textShadow3 50 0 easeOut
        ]


greenBlueBlurGradient =
    "0 0 10px #"
        ++ accentGreen
        ++ ", 0 0 15px #"
        ++ accentBlue650
        ++ ", 0 0 20px #"
        ++ accentBlue650


greenBlueInsetBlurGradient =
    "inset 0 0 10px #"
        ++ accentGreen
        ++ ", inset 0 0 15px #"
        ++ accentBlue650
        ++ ", inset 0 0 20px #"
        ++ accentBlue650


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
