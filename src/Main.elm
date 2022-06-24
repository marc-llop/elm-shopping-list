module Main exposing (main)

import Browser
import CreateNote exposing (CreateNoteFormMsg(..), createNoteView)
import Css exposing (fixed, fullWidth, height, int, pct, position, property, width, zIndex)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import List
import LocalStorage exposing (encodeAndStoreModel)
import Model exposing (..)
import Note exposing (Note, NoteId, newFakeNote, noteIdToString)
import NotesList exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Tuple
import Ui.Background exposing (background)
import Ui.Button exposing (ButtonType(..))
import Utils exposing (dataTestId)



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


initialNotesList : OpaqueDict NoteId Note
initialNotesList =
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
        |> List.indexedMap (\i note -> newFakeNote i note)
        |> OpaqueDict.fromList noteIdToString


init : { backgroundTextureUrl : String } -> ( Model, Cmd Msg )
init { backgroundTextureUrl } =
    ( { pending = initialNotesList
      , done = OpaqueDict.empty Note.noteIdToString
      , currentPage = ListPage
      , constants =
            { backgroundTextureUrl = backgroundTextureUrl
            }
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


editNote : NoteId -> Note -> OpaqueDict NoteId Note -> OpaqueDict NoteId Note
editNote id note =
    OpaqueDict.update id (Maybe.map (always note))


applyIfEditNotePage : Model -> (NoteId -> Note -> Model) -> Model
applyIfEditNotePage model fn =
    case model.currentPage of
        EditNotePage noteId note ->
            fn noteId note

        _ ->
            model


storeAndThen : Cmd a -> Model -> Cmd a
storeAndThen cmd newModel =
    Cmd.batch
        [ cmd
        , encodeAndStoreModel newModel
        ]


type alias UpdateFn a =
    a -> Model -> ( Model, Cmd a )


handlePageUpdate : UpdateFn a -> (a -> Msg) -> a -> Model -> ( Model, Cmd Msg )
handlePageUpdate updateFn mapper msg model =
    let
        ( newModel, localCmd ) =
            updateFn msg model

        globalCmd =
            Cmd.map mapper localCmd
    in
    ( newModel, storeAndThen globalCmd newModel )


update : UpdateFn Msg
update msg model =
    case msg of
        NotesListMsgContainer notesListMsg ->
            handlePageUpdate NotesList.update NotesListMsgContainer notesListMsg model

        CreateNoteFormMsgContainer createNoteMsg ->
            handlePageUpdate CreateNote.update CreateNoteFormMsgContainer createNoteMsg model

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
    , body = [ background model.constants.backgroundTextureUrl, body ] |> List.map toUnstyled
    }


view : Model -> Browser.Document Msg
view model =
    let
        page =
            case model.currentPage of
                ListPage ->
                    notesListView model |> Html.Styled.map NotesListMsgContainer

                CreateNotePage note ->
                    createNoteView model note |> Html.Styled.map CreateNoteFormMsgContainer

                EditNotePage noteId note ->
                    editNoteView noteId note |> Html.Styled.map EditNoteFormMsgContainer
    in
    viewPage model page


editNoteView : NoteId -> Note -> Html EditNoteFormMsg
editNoteView noteId note =
    Html.Styled.form
        [ dataTestId "EditNote"
        , onSubmit (EditNote noteId note)
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputEditedNoteTitle, value note.title, id editNoteAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Save note"
            , isEnabled = not (String.isEmpty note.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelEdit
            , label = "Cancel edit"
            , isEnabled = True
            }
        ]
