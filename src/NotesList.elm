module NotesList exposing (NotesListMsg(..), notesListView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import List
import Note exposing (Note, NoteId)
import Model exposing (Model)
import OpaqueDict exposing (OpaqueDict)
import Utils exposing (classStrList)


type NotesListMsg
    = Tick NoteId
    | Untick NoteId
    | OpenCreateNote
    | OpenEditNote NoteId Note
    | RemoveNote NoteId


notesListView : Model -> Html NotesListMsg
notesListView { pending, done } =
    div [ class "fullscreen" ]
        [ ul [ classStrList [ "reset-ul" ] ]
            (List.concat
                [ noteDictToList pending |> List.map pendingNoteView
                , noteDictToList done |> List.map doneNoteView
                ]
            )
        , createNoteButtonView
        ]



-- Returns the (id, note) pairs alphabetically sorted by note title


noteDictToList : OpaqueDict NoteId Note -> List ( NoteId, Note )
noteDictToList dict =
    OpaqueDict.toList dict
        |> List.sortBy (Tuple.second >> .title)


pendingNoteView : ( NoteId, Note ) -> Html NotesListMsg
pendingNoteView ( noteId, note ) =
    li [ classStrList [ "reset-li", "item" ] ]
        [ span [ class "noteTitle" ] [ text note.title ]
        , button [ onClick (RemoveNote noteId) ] [ text "🗑️" ]
        , button [ onClick (OpenEditNote noteId note) ] [ text "✏️" ]
        ]


doneNoteView =
    pendingNoteView


createNoteButtonView : Html NotesListMsg
createNoteButtonView =
    button [ onClick OpenCreateNote ] [ text "+" ]
