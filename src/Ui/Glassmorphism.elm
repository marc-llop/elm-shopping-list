module Ui.Glassmorphism exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (backgroundPurple, neutral)
import ElmBook exposing (Msg)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)


docs : Chapter x
docs =
    let
        background : Html msg
        background =
            div
                [ css
                    [ Css.property "background" "repeating-conic-gradient(#808080 0% 25%, transparent 0% 50%) 50% / 20px 20px"
                    , Css.width (px 400)
                    , Css.height (px 400)
                    ]
                ]
                []
    in
    chapter "Glassmorphism"
        |> renderComponentList
            [ ( "Card", background )
            ]
