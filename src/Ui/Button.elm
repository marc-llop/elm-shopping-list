module Ui.Button exposing (button, docs)

import Css exposing (..)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html
import Html.Styled exposing (Html, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)


buttonStyles =
    [ displayFlex
    , minWidth (px 100)
    , borderRadius (px 20)
    , backgroundColor transparent
    , justifyContent center
    ]


button : { label : String, onUse : msg } -> Html msg
button { label, onUse } =
    Html.Styled.button
        [ css buttonStyles, onClick onUse ]
        [ span [] [ text label ] ]


docs : Chapter x
docs =
    let
        props =
            { label = "Accept"
            , onUse = logAction "Button clicked"
            }
    in
    chapter "Buttons"
        |> renderComponentList
            [ ( "Default", button props )
            , ( "With other text", button { props | label = "Hi" } )
            ]
