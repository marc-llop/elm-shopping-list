module Ui.NoteList exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Keyed exposing (ul)
import ItemModel exposing (IdItemPair, itemIdToString)
import Utils exposing (dataTestId)


type alias ChecklistProps msg =
    { pending : List IdItemPair
    , done : List IdItemPair
    , pendingItemView : IdItemPair -> Html msg
    , doneItemView : IdItemPair -> Html msg
    }


resetUlStyle : List Style
resetUlStyle =
    [ margin zero
    , padding zero
    ]


checklistStyle : List Style
checklistStyle =
    resetUlStyle
        ++ [ displayFlex
           , flexDirection column
           , marginBottom (px 120)
           ]


keyedItemView : (IdItemPair -> Html msg) -> IdItemPair -> ( String, Html msg )
keyedItemView mapper pair =
    ( Tuple.first pair |> itemIdToString, mapper pair )


checklistView : ChecklistProps msg -> Html msg
checklistView { pending, done, pendingItemView, doneItemView } =
    ul
        [ dataTestId "Checklist"
        , css checklistStyle
        ]
        (List.concat
            [ List.map (keyedItemView pendingItemView) pending
            , List.map (keyedItemView doneItemView) done
            ]
        )
