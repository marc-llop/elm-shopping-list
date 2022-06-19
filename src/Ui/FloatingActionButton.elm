module Ui.FloatingActionButton exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (accentBlue, accentGreen)
import DesignSystem.Icons as Icons
import ElmBook exposing (Msg)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import NamedInterpolate exposing (interpolate)
import Ui.Glassmorphism exposing (glassmorphism)
import Utils exposing (dataTestId)


floatingActionButtonStyles : List Style
floatingActionButtonStyles =
    glassmorphism
        { color = accentBlue.s500
        , opacityPct = 60
        , blurPx = 10
        , saturationPct = 100
        }
        ++ [ displayFlex
           , alignItems center
           , padding (px 10)
           , borderRadius (px 10)
           , cursor pointer
           , color (hex accentGreen.s200)
           , borderStyle none
           , boxShadow3 (px 2) (px 2) (hex accentBlue.s700)
           ]


iconStyles =
    [ Css.property
        "filter"
        (interpolate
            "drop-shadow(0 0 3px #{color})"
            [ ( "color", accentGreen.s250 ) ]
        )
    ]


floatingActionButtonView : msg -> Html msg
floatingActionButtonView onClick =
    button
        [ dataTestId "FloatingActionButton"
        , css floatingActionButtonStyles
        ]
        [ Icons.plus iconStyles ]


docs : Chapter x
docs =
    let
        onClick =
            logAction "Clicked"
    in
    chapter "FAB"
        |> renderComponentList
            [ ( "Floating Action Button", floatingActionButtonView onClick )
            ]
