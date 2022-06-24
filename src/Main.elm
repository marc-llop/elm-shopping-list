module Main exposing (main)

import Browser
import CreateNotePage exposing (CreateNoteFormMsg(..), createNoteView)
import Css exposing (fixed, fullWidth, height, int, pct, position, property, width, zIndex)
import EditNotePage exposing (EditNoteFormMsg(..), editNoteView)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import List
import LocalStorage exposing (encodeAndStoreModel)
import Model exposing (..)
import Note exposing (Note, NoteId, newFakeNote, noteIdToString)
import NotesListPage exposing (NotesListMsg(..), notesListView)
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
            handlePageUpdate NotesListPage.update NotesListMsgContainer notesListMsg model

        CreateNoteFormMsgContainer createNoteMsg ->
            handlePageUpdate CreateNotePage.update CreateNoteFormMsgContainer createNoteMsg model

        EditNoteFormMsgContainer editNoteMsg ->
            handlePageUpdate EditNotePage.update EditNoteFormMsgContainer editNoteMsg model



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
