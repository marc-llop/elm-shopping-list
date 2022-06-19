-- Icons from elm-feather using https://1602.github.io/elm-feather-icons/


module DesignSystem.Icons exposing (..)

import ElmBook exposing (Msg)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html)
import Svg.Styled exposing (Svg, svg)
import Svg.Styled.Attributes exposing (..)


svgFeatherIcon : String -> List (Svg msg) -> Html msg
svgFeatherIcon className =
    svg
        [ class <| "feather feather-" ++ className
        , fill "none"
        , height "24"
        , stroke "currentColor"
        , strokeLinecap "round"
        , strokeLinejoin "round"
        , strokeWidth "2"
        , viewBox "0 0 24 24"
        , width "24"
        ]


checkSquare : Html msg
checkSquare =
    svgFeatherIcon "check-square"
        [ Svg.Styled.polyline [ points "9 11 12 14 22 4" ] []
        , Svg.Styled.path [ d "M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" ] []
        ]


edit2 : Html msg
edit2 =
    svgFeatherIcon "edit-2"
        [ Svg.Styled.path [ d "M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z" ] []
        ]


plus : Html msg
plus =
    svgFeatherIcon "plus"
        [ Svg.Styled.line [ x1 "12", y1 "5", x2 "12", y2 "19" ] []
        , Svg.Styled.line [ x1 "5", y1 "12", x2 "19", y2 "12" ] []
        ]


square : Html msg
square =
    svgFeatherIcon "square"
        [ Svg.Styled.rect [ Svg.Styled.Attributes.x "3", y "3", width "18", height "18", rx "2", ry "2" ] []
        ]


trash2 : Html msg
trash2 =
    svgFeatherIcon "trash-2"
        [ Svg.Styled.polyline [ points "3 6 5 6 21 6" ] []
        , Svg.Styled.path [ d "M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" ] []
        , Svg.Styled.line [ x1 "10", y1 "11", x2 "10", y2 "17" ] []
        , Svg.Styled.line [ x1 "14", y1 "11", x2 "14", y2 "17" ] []
        ]


docs : Chapter x
docs =
    let
        a =
            []
    in
    chapter "Icons"
        |> renderComponentList
            [ ( "Square", square )
            , ( "CheckSquare", checkSquare )
            , ( "Edit2", edit2 )
            , ( "Trash2", trash2 )
            , ( "Plus", plus )
            ]
