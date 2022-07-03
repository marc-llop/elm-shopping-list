module NotesListPage exposing (NotesListMsg(..), notesListView, update)

import Browser.Dom
import Css exposing (..)
import DesignSystem.Colors exposing (neutral)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import ItemModel exposing (..)
import List
import Model exposing (Model, move, sortNotes)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Task
import Ui.Checklist exposing (checklistView)
import Ui.FloatingActionButton exposing (floatingActionButtonView)
import Ui.Item exposing (ItemProps, itemView)
import Utils exposing (dataTestId)


type NotesListMsg
    = Tick ItemId
    | Untick ItemId
    | OpenCreateNote
    | OpenEditNote ItemId Item
    | RemoveNote ItemId
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
            ( { model | currentPage = EditNotePage noteId note note }
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


resetNoteForm : Item
resetNoteForm =
    { title = "" }


notesListView : Model -> Html NotesListMsg
notesListView { pending, done } =
    let
        pendingNotes =
            noteDictToList pending

        doneNotes =
            noteDictToList done
    in
    div [ dataTestId "NotesListPage", css [ Css.width (pct 100) ] ]
        [ checklistView
            { pending = pendingNotes
            , done = doneNotes
            , pendingItemView = pendingItemView
            , doneItemView = doneItemView
            }
        , createNoteButtonView
        ]



-- Returns the (id, note) pairs alphabetically sorted by note title


noteDictToList : OpaqueDict ItemId Item -> List IdItemPair
noteDictToList dict =
    OpaqueDict.toList dict
        |> sortNotes


pendingItemView : ( ItemId, Item ) -> Html NotesListMsg
pendingItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state =
            Ui.Item.Pending
                { onRemove = RemoveNote
                , onEdit = OpenEditNote
                }
        , onTick = Tick
        }


doneItemView : ( ItemId, Item ) -> Html NotesListMsg
doneItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state =
            Ui.Item.Done
                { onRemove = RemoveNote
                , onEdit = OpenEditNote
                }
        , onTick = Untick
        }


createNoteButtonView : Html NotesListMsg
createNoteButtonView =
    floatingActionButtonView { onClick = OpenCreateNote, styles = [] }
