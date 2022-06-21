module DesignSystem.ColorDecisions exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (..)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


neutralTextColor =
    neutral.s300



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
