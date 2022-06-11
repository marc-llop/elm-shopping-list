module NotesList exposing (NotesListMsg(..), notesListView, update)

import Browser.Dom
import Css exposing (..)
import DesignSystem.Colors exposing (neutral)
import ElmBook exposing (Msg)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import List
import Model exposing (Model, move)
import Note exposing (..)
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
                    Model.move noteId model.pending model.done
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
                    Model.move noteId model.done model.pending
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


notesListView : Model -> Html NotesListMsg
notesListView { pending, done } =
    div [ css [ Css.width (pct 100) ] ]
        [ ul [ css noteListStyle ]
            (List.concat
                [ noteDictToList pending |> List.map pendingNoteView
                , noteDictToList done |> List.map doneNoteView
                ]
            )
        , createNoteButtonView
        ]



-- Returns the (id, note) pairs alphabetically sorted by note title


noteDictToList : OpaqueDict NoteId Note -> List NoteIdPair
noteDictToList dict =
    OpaqueDict.toList dict
        |> List.sortBy (Tuple.second >> .title)


noteView : List Style -> (NoteId -> NotesListMsg) -> ( NoteId, Note ) -> Html NotesListMsg
noteView styles clickMsg ( noteId, note ) =
    li [ css styles, onClick (clickMsg noteId) ]
        [ span [ css noteTitleStyle ] [ text note.title ]
        , button [ onClick (RemoveNote noteId) ] [ text "🗑️" ]
        , button [ onClick (OpenEditNote noteId note) ] [ text "✏️" ]
        ]


pendingNoteView : ( NoteId, Note ) -> Html NotesListMsg
pendingNoteView =
    noteView (noteStyle Pending) Tick


doneNoteView : ( NoteId, Note ) -> Html NotesListMsg
doneNoteView =
    noteView (noteStyle Done) Untick


createNoteButtonView : Html NotesListMsg
createNoteButtonView =
    button [ onClick OpenCreateNote ] [ text "+" ]
