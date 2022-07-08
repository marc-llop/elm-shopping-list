module DesignSystem.ColorDecisions exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (..)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Ui.Glassmorphism exposing (GlassmorphismProps)


neutralTextColor =
    neutral.s300


glassButtonGlowingColor : GlassmorphismProps
glassButtonGlowingColor =
    { color = accentBlue.s500
    , opacityPct = 40
    , blurPx = 7
    , saturationPct = 100
    }


glassButtonInertColor : GlassmorphismProps
glassButtonInertColor =
    { color = accentBlue.s500
    , opacityPct = 20
    , blurPx = 4
    , saturationPct = 0
    }


glassButtonGlowingBoxShadowColor =
    accentBlue.s800


glassButtonInertBoxShadowColor =
    translucentDarkGrey


activeButtonTextColor =
    white


deleteIconColor =
    red


neutralCardColor : GlassmorphismProps
neutralCardColor =
    { color = neutral.s750
    , opacityPct = 35
    , blurPx = 6
    , saturationPct = 100
    }


neutralCardBoxShadowColor =
    neutral.s750


neutralCardTextShadowColor =
    neutral.s500



-- Tokens end here. Docs rendering below.


colorBlock c =
    div
        [ css
            [ width (px 100)
            , height (px 24)
            , backgroundColor (hex c)
            ]
        ]
        []


token ( name, c ) =
    tr
        []
        [ td [ css [ paddingRight (px 20) ] ] [ text name ]
        , td [] [ colorBlock c ]
        , td [ css [ paddingLeft (px 20) ] ] [ text ("#" ++ c) ]
        ]


tokens =
    Html.Styled.table
        [ css [ color (hex white) ] ]
        (List.map token colorTokens)


colorTokens =
    [ ( "neutralTextColor", neutralTextColor )
    , ( "glassButtonGlowingBoxShadowColor", glassButtonGlowingBoxShadowColor )
    , ( "glassButtonInertBoxShadowColor", glassButtonInertBoxShadowColor )
    , ( "neutralCardBoxShadowColor", neutralCardBoxShadowColor )
    , ( "neutralCardTextShadowColor", neutralCardTextShadowColor )
    , ( "activeButtonTextColor", activeButtonTextColor )
    , ( "deleteIconColor", deleteIconColor )
    , ( "Glassmorphism glassButtonGlowingColor.color", glassButtonGlowingColor.color )
    , ( "Glassmorphism glassButtonInertColor.color", glassButtonInertColor.color )
    , ( "Glassmorphism neutralCardColor.color", neutralCardColor.color )
    ]


docs : Chapter x
docs =
    chapter "Color Decisions"
        |> renderComponentList
            [ ( "Tokens", tokens )
            ]
