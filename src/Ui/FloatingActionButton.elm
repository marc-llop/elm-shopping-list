module Ui.FloatingActionButton exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (accentBlue, accentGreen)
import DesignSystem.StyledIcons as Icons
import ElmBook exposing (Msg)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events as Evt exposing (onClick)
import Ui.Glassmorphism exposing (glassmorphism)
import Utils exposing (dataTestId, transparencyBackground)


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
        , justifyContent center
        , position fixed
        , bottom (px 30)
        , right (px 30)
        , Css.width (px 65)
        , Css.height (px 65)
        , borderRadius (px 10)
        , cursor pointer
        , borderStyle none
        , boxShadow3 (px 2) (px 2) (hex accentBlue.s700)
        ]


floatingActionButtonView : FabProps msg -> Html msg
floatingActionButtonView { onClick, styles } =
    button
        [ dataTestId "FloatingActionButton"
        , css [ floatingActionButtonStyles, Css.batch styles ]
        , Evt.onClick onClick
        ]
        [ Icons.greenPlus ]


docs : Chapter x
docs =
    let
        props =
            { onClick = logAction "Clicked"
            , styles =
                [ position relative
                , bottom zero
                , right zero
                , left (px 7)
                ]
            }

        showcaseFab p =
            transparencyBackground
                { width = 80, height = 80 }
                (floatingActionButtonView p)
    in
    chapter "FAB"
        |> renderComponentList
            [ ( "Floating Action Button", showcaseFab props )
            ]
