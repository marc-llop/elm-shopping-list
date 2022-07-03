module Ui.Button exposing (ButtonType(..), button, docs)

import Css exposing (..)
import Css.Transitions exposing (easeOut, transition)
import DesignSystem.Colors exposing (..)
import DesignSystem.Sizes exposing (itemFontSize)
import ElmBook
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, span, text)
import Html.Styled.Attributes as HtmlAttr exposing (css)
import Html.Styled.Events as HtmlEvt
import Json.Decode
import NamedInterpolate exposing (interpolate)
import Utils exposing (dataTestId)


buttonStyles : Bool -> List Style
buttonStyles isEnabled =
    (if isEnabled then
        enabledButtonStyles

     else
        disabledButtonStyles
    )
        ++ [ displayFlex
           , minWidth (px 100)
           , padding2 (px 10) (px 20)
           , justifyContent center
           , fontSize itemFontSize
           , backgroundColor transparent
           , borderRadius (px 10)
           , buttonTransition 200
           ]


enabledButtonStyles : List Style
enabledButtonStyles =
    [ color (hex neutral.s300)
    , border3 (px 2) solid (hex neutral.s100)
    , property "box-shadow" (shadow 10 neutral.s300 ++ ", " ++ insetShadow 10 neutral.s300)
    , cursor pointer
    , hover hoverStyles
    , active activeStyles
    , focus
        [ outline3 (px 3) solid (hex neutral.s300)
        ]
    ]


disabledButtonStyles : List Style
disabledButtonStyles =
    [ color (hex accentBlue.s250)
    , border3 (px 2) solid (hex accentBlue.s300)
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
    , isEnabled : Bool
    , customStyle : List Style
    }
    -> Html msg
stylableButton { label, buttonType, isEnabled, customStyle } =
    let
        attrs =
            case buttonType of
                Submit ->
                    [ HtmlAttr.type_ "submit" ]

                Button msg ->
                    [ HtmlEvt.on "touchstart" (Json.Decode.succeed msg)
                    , HtmlEvt.onClick msg
                    , HtmlAttr.type_ "button"
                    ]

        attrsWithDisabled =
            if isEnabled then
                attrs

            else
                HtmlAttr.disabled True :: attrs

        joinedStyles =
            css (List.concat [ buttonStyles isEnabled, customStyle ])
    in
    Html.Styled.button
        (dataTestId "Button" :: joinedStyles :: attrsWithDisabled)
        [ span [] [ text label ] ]


button :
    { label : String
    , buttonType : ButtonType msg
    , isEnabled : Bool
    }
    -> Html msg
button { label, buttonType, isEnabled } =
    stylableButton
        { label = label
        , buttonType = buttonType
        , isEnabled = isEnabled
        , customStyle = []
        }


docs : Chapter x
docs =
    let
        props =
            { label = "Accept"
            , buttonType = Button (logAction "Button clicked")
            , isEnabled = True
            , customStyle = [ margin (px 20) ]
            }
    in
    chapter "Button"
        |> renderComponentList
            [ ( "Default", stylableButton props )
            , ( "Hovered", stylableButton { props | customStyle = margin (px 20) :: hoverStyles } )
            , ( "Active", stylableButton { props | customStyle = margin (px 20) :: activeStyles } )
            , ( "Disabled", stylableButton { props | isEnabled = False } )
            ]
