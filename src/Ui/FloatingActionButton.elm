module Ui.FloatingActionButton exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (..)
import DesignSystem.Colors exposing (accentBlue, accentGreen, translucentDarkGrey)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow)
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
        [ displayFlex
        , alignItems center
        , justifyContent center
        , position fixed
        , bottom (px 30)
        , right (px 30)
        , Css.width (px 65)
        , Css.height (px 65)
        , borderRadius cardBorderRadius
        , cursor pointer
        , borderStyle none
        , inertStyle
        , hover [ glowingStyle ]
        ]


glowingStyle : Style
glowingStyle =
    Css.batch
        [ glassmorphism glassButtonGlowing
        , cardBoxShadow (hex glassButtonGlowingBoxShadowColor)
        ]


inertStyle : Style
inertStyle =
    Css.batch
        [ glassmorphism glassButtonInert
        , cardBoxShadow (hex glassButtonInertBoxShadowColor)
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
    chapter "FloatingActionButton"
        |> renderComponentList
            [ ( "Default", showcaseFab props )
            , ( "Hovered", showcaseFab { props | styles = glowingStyle :: props.styles } )
            ]
