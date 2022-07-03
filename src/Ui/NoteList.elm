module Ui.NoteList exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Keyed exposing (ul)
import ItemModel exposing (IdItemPair, ItemId, itemIdToString)
import Utils exposing (dataTestId)


type alias NoteListProps msg =
    { pending : List IdItemPair
    , done : List IdItemPair
    , pendingNoteView : IdItemPair -> Html msg
    , doneNoteView : IdItemPair -> Html msg
    }


resetUlStyle : List Style
resetUlStyle =
    [ margin zero
    , padding zero
    ]


noteListStyle : List Style
noteListStyle =
    resetUlStyle
        ++ [ displayFlex
           , flexDirection column
           , marginBottom (px 120)
           ]


keyedItemView : (IdItemPair -> Html msg) -> IdItemPair -> ( String, Html msg )
keyedItemView mapper pair =
    ( Tuple.first pair |> itemIdToString, mapper pair )


noteListView : NoteListProps msg -> Html msg
noteListView { pending, done, pendingNoteView, doneNoteView } =
    ul
        [ dataTestId "NoteList"
        , css noteListStyle
        ]
        (List.concat
            [ List.map (keyedItemView pendingNoteView) pending
            , List.map (keyedItemView doneNoteView) done
            ]
        )
