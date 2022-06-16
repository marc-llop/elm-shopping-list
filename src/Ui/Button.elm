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
import NamedInterpolate exposing (interpolate)


buttonStyles : List Style
buttonStyles =
    [ displayFlex
    , minWidth (px 100)
    , padding2 (px 10) (px 20)
    , justifyContent center
    , fontSize (rem 1.2)
    , color (hex neutral.s300)
    , backgroundColor transparent
    , border3 (px 2) solid (hex neutral.s100)
    , borderRadius (px 10)
    , property "box-shadow" (shadow 10 neutral.s300 ++ ", " ++ insetShadow 10 neutral.s300)
    , cursor pointer
    , buttonTransition 200
    , hover hoverStyles
    , active activeStyles
    , focus
        [ outline3 (px 3) solid (hex neutral.s300)
        ]
    ]


hoverStyles =
    [ borderColor (hex backgroundPurple.s100)
    , color (hex backgroundPurple.s100)
    , property "text-shadow" purpleShadow
    , property "box-shadow" purpleInsetShadow
    , buttonTransition 50
    , focus [ outline3 (px 3) solid (hex backgroundPurple.s250) ]
    ]


activeStyles =
    [ borderColor (hex white)
    , color (hex white)
    , property "text-shadow" greenBlueShadow
    , property "box-shadow" greenBlueInsetShadow
    , focus [ outline none ]
    ]


buttonTransition duration =
    transition
        [ Css.Transitions.color3 duration 0 easeOut
        , Css.Transitions.boxShadow3 duration 0 easeOut
        , Css.Transitions.border3 duration 50 easeOut
        , Css.Transitions.textShadow3 duration 0 easeOut
        ]


shadow : Int -> String -> String
shadow sizeInt color =
    interpolate
        "0 0 {size}px #{color}"
        [ ( "size", String.fromInt sizeInt )
        , ( "color", color )
        ]


insetShadow : Int -> String -> String
insetShadow size color =
    "inset " ++ shadow size color


greenBlueShadow =
    [ shadow 12 accentGreen.s400
    , shadow 18 accentBlue.s400
    ]
        |> String.join ", "


greenBlueInsetShadow =
    [ shadow 12 accentGreen.s400
    , shadow 18 accentBlue.s400
    , insetShadow 12 accentGreen.s400
    , insetShadow 18 accentBlue.s400
    ]
        |> String.join ", "


purpleShadow =
    [ shadow 10 backgroundPurple.s350
    , shadow 15 backgroundPurple.s350
    ]
        |> String.join ", "


purpleInsetShadow =
    [ shadow 10 backgroundPurple.s350
    , shadow 15 backgroundPurple.s350
    , insetShadow 10 backgroundPurple.s350
    , insetShadow 15 backgroundPurple.s350
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
    in
    chapter "Button"
        |> renderComponentList
            [ ( "Default", stylableButton props )
            , ( "Hovered", stylableButton { props | customStyle = hoverStyles } )
            , ( "Active", stylableButton { props | customStyle = activeStyles } )
            ]
