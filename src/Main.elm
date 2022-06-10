module Main exposing (main)

import Background exposing (background)
import Browser
import Css exposing (fixed, height, int, pct, position, property, width, zIndex)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import List
import Model exposing (..)
import Note exposing (Note, NoteId)
import NotesList exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Tuple
import Ui.Button exposing (ButtonType(..))



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


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


init : { backgroundTextureUrl : String } -> ( Model, Cmd Msg )
init { backgroundTextureUrl } =
    ( { pending = OpaqueDict.empty Note.noteIdToString |> insertInitialNotesList
      , done = OpaqueDict.empty Note.noteIdToString
      , idCounter = 100
      , currentPage = ListPage
      , backgroundTextureUrl = backgroundTextureUrl
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NotesListMsgContainer NotesListMsg
    | CreateNoteFormMsgContainer CreateNoteFormMsg
    | EditNoteFormMsgContainer EditNoteFormMsg


type EditNoteFormMsg
    = InputEditedNoteTitle String
    | EditNote NoteId Note
    | CancelEdit


type CreateNoteFormMsg
    = InputNewNoteTitle String
    | CreateNote Note
    | CancelCreate


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NotesListMsgContainer notesListMsg ->
            NotesList.update notesListMsg model
                |> Tuple.mapSecond (Cmd.map NotesListMsgContainer)

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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewPage : Model -> Html Msg -> Browser.Document Msg
viewPage model body =
    { title = "Elm Shopping List"
    , body = [ background model.backgroundTextureUrl, body ] |> List.map toUnstyled
    }


view : Model -> Browser.Document Msg
view model =
    let
        page =
            case model.currentPage of
                ListPage ->
                    notesListView model |> Html.Styled.map NotesListMsgContainer

                CreateNotePage note ->
                    createNoteView note |> Html.Styled.map CreateNoteFormMsgContainer

                EditNotePage noteId note ->
                    editNoteView noteId note |> Html.Styled.map EditNoteFormMsgContainer
    in
    viewPage model page


createNoteView : Note -> Html CreateNoteFormMsg
createNoteView newNote =
    Html.Styled.form [ onSubmit (CreateNote newNote) ]
        [ input [ onInput InputNewNoteTitle, value newNote.title, id createNoteAutofocusId ] []
        , Ui.Button.button { buttonType = Submit, label = "Add note" }
        , Ui.Button.button { buttonType = Button CancelCreate, label = "Cancel" }
        ]


editNoteView : NoteId -> Note -> Html EditNoteFormMsg
editNoteView noteId note =
    Html.Styled.form [ onSubmit (EditNote noteId note) ]
        [ input [ onInput InputEditedNoteTitle, value note.title, id editNoteAutofocusId ] []
        , Ui.Button.button { buttonType = Submit, label = "Save note" }
        , Ui.Button.button { buttonType = Button CancelEdit, label = "Cancel edit" }
        ]
