module NotesList exposing (NotesListMsg(..), notesListView, update)

import Browser.Dom
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import List
import Model exposing (Model)
import Note exposing (Note, NoteId)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Task
import Utils exposing (classStrList)


type NotesListMsg
    = Tick NoteId
    | Untick NoteId
    | OpenCreateNote
    | OpenEditNote NoteId Note
    | RemoveNote NoteId
    | NoOp


update : NotesListMsg -> Model -> ( Model, Cmd NotesListMsg )
update msg model =
    case ( msg, model.currentPage ) of
        ( Tick noteId, ListPage ) ->
            let
                ( newPending, newDone ) =
                    move noteId model.pending model.done
            in
            ( { model
                | pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        ( Untick noteId, ListPage ) ->
            let
                ( newDone, newPending ) =
                    move noteId model.done model.pending
            in
            ( { model
                | pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        ( OpenCreateNote, ListPage ) ->
            ( { model
                | currentPage = CreateNotePage resetNoteForm
              }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus createNoteAutofocusId)
            )

        ( OpenEditNote noteId note, ListPage ) ->
            ( { model | currentPage = EditNotePage noteId note }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus editNoteAutofocusId)
            )

        ( RemoveNote noteId, ListPage ) ->
            ( { model
                | pending = OpaqueDict.remove noteId model.pending
                , done = OpaqueDict.remove noteId model.done
              }
            , Cmd.none
            )

        ( _, _ ) ->
            ( model, Cmd.none )


resetNoteForm : Note
resetNoteForm =
    { title = "" }


move : k -> OpaqueDict k v -> OpaqueDict k v -> ( OpaqueDict k v, OpaqueDict k v )
move k dictFrom dictTo =
    let
        elem =
            OpaqueDict.get k dictFrom

        newFrom =
            OpaqueDict.remove k dictFrom

        newTo =
            elem
                |> Maybe.map (\e -> OpaqueDict.insert k e dictTo)
                |> Maybe.withDefault dictTo
    in
    ( newFrom, newTo )


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
