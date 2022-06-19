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
import Html.Styled.Events as Evt exposing (onClick)
import NamedInterpolate exposing (interpolate)
import Ui.Glassmorphism exposing (glassmorphism)
import Utils exposing (dataTestId)


type alias FabProps msg =
    { onClick : msg
    , styles : List Style
    }


floatingActionButtonStyles : Style
floatingActionButtonStyles =
    Css.batch
        [ glassmorphism
            { color = accentBlue.s500
            , opacityPct = 40
            , blurPx = 10
            , saturationPct = 100
            }
        , displayFlex
        , alignItems center
        , position fixed
        , bottom (px 30)
        , right (px 30)
        , padding (px 15)
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
    , Css.width (px 35)
    , Css.height (px 35)
    ]


floatingActionButtonView : FabProps msg -> Html msg
floatingActionButtonView { onClick, styles } =
    button
        [ dataTestId "FloatingActionButton"
        , css [ floatingActionButtonStyles, Css.batch styles ]
        , Evt.onClick onClick
        ]
        [ Icons.plus iconStyles ]


docs : Chapter x
docs =
    let
        props =
            { onClick = logAction "Clicked"
            , styles =
                [ position relative
                , bottom zero
                , right zero
                ]
            }
    in
    chapter "FAB"
        |> renderComponentList
            [ ( "Floating Action Button", floatingActionButtonView props )
            ]
