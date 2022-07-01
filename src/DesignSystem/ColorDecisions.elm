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


glassButtonGlowing : GlassmorphismProps
glassButtonGlowing =
    { color = accentBlue.s500
    , opacityPct = 40
    , blurPx = 7
    , saturationPct = 100
    }


glassButtonInert : GlassmorphismProps
glassButtonInert =
    { color = accentBlue.s500
    , opacityPct = 20
    , blurPx = 4
    , saturationPct = 0
    }


glassButtonGlowingBoxShadowColor =
    accentBlue.s800


glassButtonInertBoxShadowColor =
    translucentDarkGrey



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
        ]


tokens =
    Html.Styled.table
        [ css [ color (hex white) ] ]
        (List.map token colorTokens)


colorTokens =
    [ ( "neutralTextColor", neutralTextColor )
    ]


docs : Chapter x
docs =
    chapter "Color Decisions"
        |> renderComponentList
            [ ( "Tokens", tokens )
            ]
