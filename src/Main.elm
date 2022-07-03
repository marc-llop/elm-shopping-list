module Main exposing (main)

import Browser
import ChecklistPage exposing (ChecklistMsg(..), checklistPageView)
import CreateItemPage exposing (CreateItemFormMsg(..), createItemView)
import Css exposing (fixed, fullWidth, height, int, pct, position, property, width, zIndex)
import EditItemPage exposing (EditItemFormMsg(..), editItemView)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import ItemModel exposing (Item, ItemId, itemIdToString, newFakeItem)
import Json.Decode as D
import List
import LocalStorage exposing (encodeAndStoreModel)
import Model exposing (..)
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


initialNotesList : OpaqueDict ItemId Item
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
        |> List.indexedMap (\i note -> newFakeItem i note)
        |> OpaqueDict.fromList itemIdToString


init :
    D.Value
    -> ( Model, Cmd Msg )
init json =
    let
        model =
            D.decodeValue decodeModel json
                |> Result.toMaybe
                |> Maybe.withDefault
                    (initModel
                        "backgroundTextureUrl not found"
                        initialNotesList
                        (OpaqueDict.empty ItemModel.itemIdToString)
                    )
    in
    ( model, Cmd.none )



-- UPDATE


type Msg
    = NotesListMsgContainer ChecklistMsg
    | CreateNoteFormMsgContainer CreateItemFormMsg
    | EditNoteFormMsgContainer EditItemFormMsg


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
            handlePageUpdate ChecklistPage.update NotesListMsgContainer notesListMsg model

        CreateNoteFormMsgContainer createNoteMsg ->
            handlePageUpdate CreateItemPage.update CreateNoteFormMsgContainer createNoteMsg model

        EditNoteFormMsgContainer editNoteMsg ->
            handlePageUpdate EditItemPage.update EditNoteFormMsgContainer editNoteMsg model



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
                ChecklistPage ->
                    checklistPageView model |> Html.Styled.map NotesListMsgContainer

                CreateItemPage note ->
                    createItemView model note |> Html.Styled.map CreateNoteFormMsgContainer

                EditItemPage noteId note originalNote ->
                    editItemView noteId note originalNote |> Html.Styled.map EditNoteFormMsgContainer
    in
    viewPage model page
