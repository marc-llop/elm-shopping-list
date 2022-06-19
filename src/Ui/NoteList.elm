module Ui.NoteList exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html, ul)
import Html.Styled.Attributes exposing (css)
import Model exposing (sortNotes)
import Note exposing (NoteIdPair)
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
           ]


noteListView : NoteListProps msg -> Html msg
noteListView { pending, done, pendingNoteView, doneNoteView } =
    ul
        [ dataTestId "NoteList"
        , css noteListStyle
        ]
        (List.concat
            [ List.map pendingNoteView pending
            , List.map doneNoteView done
            ]
        )
