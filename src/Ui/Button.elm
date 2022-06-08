module Ui.Button exposing (ButtonType(..), button, docs)

import Css exposing (..)
import Css.Transitions exposing (easeOut, transition)
import DesignSystem.Colors exposing (..)
import ElmBook exposing (Msg)
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
    , hover hoverStyles
    , active activeStyles
    , focus
        [ outline3 (px 3) solid (hex neutral300)
        ]
    ]


hoverStyles =
    [ borderColor (hex accentGreen100)
    , color (hex accentGreen100)
    , property "text-shadow" greenBlueShadow
    , property "box-shadow" greenBlueInsetShadow
    , buttonTransition 50
    , focus [ outline3 (px 3) solid (hex accentGreen100) ]
    ]


activeStyles =
    [ borderColor (hex white)
    , color (hex white)
    , property "text-shadow" whiteShadow
    , property "box-shadow" whiteInsetShadow
    , focus [ outline none ]
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


type ButtonType msg
    = Submit
    | Button msg


stylableButton :
    { label : String
    , buttonType : ButtonType msg
    , customStyle : List Style
    }
    -> Html msg
stylableButton { label, buttonType, customStyle } =
    let
        htmlOnClick =
            Html.Styled.Events.onClick

        htmlType =
            Html.Styled.Attributes.type_

        attrs =
            case buttonType of
                Submit ->
                    [ htmlType "submit" ]

                Button msg ->
                    [ htmlOnClick msg, htmlType "button" ]

        joinedStyles =
            css (List.concat [ buttonStyles, customStyle ])
    in
    Html.Styled.button
        (joinedStyles :: attrs)
        [ span [] [ text label ] ]


button :
    { label : String
    , buttonType : ButtonType msg
    }
    -> Html msg
button { label, buttonType } =
    stylableButton { label = label, buttonType = buttonType, customStyle = [] }


docs : Chapter x
docs =
    let
        props =
            { label = "Accept"
            , buttonType = Button (logAction "Button clicked")
            , customStyle = [ margin (px 20) ]
            }

        -- withMargin = styled [ ]
    in
    chapter "Button"
        |> renderComponentList
            [ ( "Default", stylableButton props )
            , ( "Hovered", stylableButton { props | customStyle = hoverStyles } )
            , ( "Active", stylableButton { props | customStyle = activeStyles } )
            ]
