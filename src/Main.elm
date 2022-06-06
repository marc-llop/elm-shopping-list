module Main exposing (main)

import Browser
import Browser.Dom
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import List
import Note exposing (Note, NoteId)
import NotesList exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Task
import Tuple



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { pending : OpaqueDict NoteId Note
    , done : OpaqueDict NoteId Note
    , idCounter : Int
    , currentPage : Page
    }


type Page
    = ListPage
    | CreateNotePage Note
    | EditNotePage NoteId Note


resetNoteForm : Note
resetNoteForm =
    { title = "" }


insertInitialNotesList : OpaqueDict NoteId Note -> OpaqueDict NoteId Note
insertInitialNotesList dict =
    [ "ous"
    , "fuet"
    , "patatones"
    , "iogurts"
    , "galetes"
    , "xocolata"
    , "tonyina"
    , "pebrots"
    , "albergínies"
    , "formatge fresc"
    , "mozzarella"
    , "patates fregides"
    , "cola"
    , "llet"
    , "pa d'hamburguesa"
    , "torrades"
    , "pa de motlle"
    , "cuixot dolç"
    , "avellanes"
    , "salsitxes"
    , "fesols"
    , "tomàquets"
    , "arròs"
    , "pasta seca"
    ]
        |> List.indexedMap (\i note -> OpaqueDict.insert (Note.intToNoteId i) (Note note))
        |> List.foldl (\fn newDict -> fn newDict) dict


init : () -> ( Model, Cmd Msg )
init _ =
    ( { pending = OpaqueDict.empty Note.noteIdToString |> insertInitialNotesList
      , done = OpaqueDict.empty Note.noteIdToString
      , idCounter = 100
      , currentPage = ListPage
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NotesListMsgContainer NotesListMsg
    | CreateNoteFormMsgContainer CreateNoteFormMsg
    | EditNoteFormMsgContainer EditNoteFormMsg
    | NoOp


type EditNoteFormMsg
    = InputEditedNoteTitle String
    | EditNote NoteId Note
    | CancelEdit


type CreateNoteFormMsg
    = InputNewNoteTitle String
    | CreateNote Note
    | CancelCreate


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


editNote : NoteId -> Note -> OpaqueDict NoteId Note -> OpaqueDict NoteId Note
editNote id note =
    OpaqueDict.update id (Maybe.map (always note))


applyIfCreateNotePage : Model -> (Note -> Model) -> Model
applyIfCreateNotePage model fn =
    case model.currentPage of
        CreateNotePage note ->
            fn note

        _ ->
            model


applyIfEditNotePage : Model -> (NoteId -> Note -> Model) -> Model
applyIfEditNotePage model fn =
    case model.currentPage of
        EditNotePage noteId note ->
            fn noteId note

        _ ->
            model


createNoteAutofocusId =
    "create-note-autofocus"


editNoteAutofocusId =
    "edit-note-autofocus"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NotesListMsgContainer (Tick noteId) ->
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

        NotesListMsgContainer (Untick noteId) ->
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

        NotesListMsgContainer OpenCreateNote ->
            ( { model
                | currentPage = CreateNotePage resetNoteForm
              }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus createNoteAutofocusId)
            )

        NotesListMsgContainer (OpenEditNote noteId note) ->
            ( { model | currentPage = EditNotePage noteId note }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus editNoteAutofocusId)
            )

        NotesListMsgContainer (RemoveNote noteId) ->
            ( { model
                | pending = OpaqueDict.remove noteId model.pending
                , done = OpaqueDict.remove noteId model.done
              }
            , Cmd.none
            )

        CreateNoteFormMsgContainer (InputNewNoteTitle title) ->
            ( applyIfCreateNotePage model
                (\note -> { model | currentPage = CreateNotePage { note | title = title } })
            , Cmd.none
            )

        CreateNoteFormMsgContainer CancelCreate ->
            ( { model | currentPage = ListPage }, Cmd.none )

        CreateNoteFormMsgContainer (CreateNote note) ->
            ( { model
                | currentPage = ListPage
                , pending =
                    OpaqueDict.insert
                        (Note.intToNoteId model.idCounter)
                        note
                        model.pending
                , idCounter = model.idCounter + 1
              }
            , Cmd.none
            )

        EditNoteFormMsgContainer (EditNote noteId note) ->
            ( { model
                | currentPage = ListPage
                , pending = editNote noteId note model.pending
                , done = editNote noteId note model.done
              }
            , Cmd.none
            )

        EditNoteFormMsgContainer (InputEditedNoteTitle title) ->
            ( applyIfEditNotePage model
                (\noteId note -> { model | currentPage = EditNotePage noteId { note | title = title } })
            , Cmd.none
            )

        EditNoteFormMsgContainer CancelEdit ->
            ( { model | currentPage = ListPage }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


background =
    div [ class "background" ] []


viewPage : Html Msg -> Browser.Document Msg
viewPage body =
    { title = "Elm Shopping List"
    , body = [ background, body ]
    }


view : Model -> Browser.Document Msg
view model =
    let
        page =
            case model.currentPage of
                ListPage ->
                    notesListView model |> Html.map NotesListMsgContainer

                CreateNotePage note ->
                    createNoteView note |> Html.map CreateNoteFormMsgContainer

                EditNotePage noteId note ->
                    editNoteView noteId note |> Html.map EditNoteFormMsgContainer
    in
    viewPage page


createNoteView : Note -> Html CreateNoteFormMsg
createNoteView newNote =
    Html.form [ onSubmit (CreateNote newNote) ]
        [ input [ onInput InputNewNoteTitle, value newNote.title, id createNoteAutofocusId ] []
        , button [ type_ "submit" ] [ text "Add note" ]
        , button [ type_ "button", onClick CancelCreate ] [ text "Cancel" ]
        ]


editNoteView : NoteId -> Note -> Html EditNoteFormMsg
editNoteView noteId note =
    Html.form [ onSubmit (EditNote noteId note) ]
        [ input [ onInput InputEditedNoteTitle, value note.title, id editNoteAutofocusId ] []
        , button [ type_ "submit" ] [ text "Save note" ]
        , button [ type_ "button", onClick CancelEdit ] [ text "Cancel edit" ]
        ]
