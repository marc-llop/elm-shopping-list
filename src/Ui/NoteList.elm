module Ui.NoteList exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Keyed exposing (ul)
import Note exposing (NoteId, NoteIdPair, noteIdToString)
import Utils exposing (dataTestId)


type alias NoteListProps msg =
    { pending : List NoteIdPair
    , done : List NoteIdPair
    , pendingNoteView : NoteIdPair -> Html msg
    , doneNoteView : NoteIdPair -> Html msg
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


keyedNoteView : (NoteIdPair -> Html msg) -> NoteIdPair -> ( String, Html msg )
keyedNoteView mapper pair =
    ( Tuple.first pair |> noteIdToString, mapper pair )


noteListView : NoteListProps msg -> Html msg
noteListView { pending, done, pendingNoteView, doneNoteView } =
    ul
        [ dataTestId "NoteList"
        , css noteListStyle
        ]
        (List.concat
            [ List.map (keyedNoteView pendingNoteView) pending
            , List.map (keyedNoteView doneNoteView) done
            ]
        )
