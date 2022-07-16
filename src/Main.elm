module Main exposing (main)

import Browser
import ChecklistModel exposing (Checklist)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import ItemModel exposing (Item, ItemId, ItemStatus(..), newFakeItem)
import Json.Decode as D
import List
import LocalStorage exposing (encodeAndStoreModel)
import Model exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Pages.ChecklistPage exposing (ChecklistMsg(..), checklistPageView)
import Pages.CreateItemPage exposing (CreateItemFormMsg(..), createItemView)
import Pages.EditItemPage exposing (EditItemFormMsg(..), editItemView)
import Ui.Background exposing (background)
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


initialItemsList : Checklist
initialItemsList =
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
        |> List.map (\item -> newFakeItem item Unticked)
        |> ChecklistModel.fromList


init :
    D.Value
    -> ( Model, Cmd Msg )
init json =
    let
        model =
            D.decodeValue (decodeModel initialItemsList) json
                |> Result.toMaybe
                |> Maybe.withDefault
                    (initModel
                        "backgroundTextureUrl not found"
                        ChecklistModel.empty
                    )
    in
    ( model, Cmd.none )



-- UPDATE


type Msg
    = ChecklistMsgContainer ChecklistMsg
    | CreateItemFormMsgContainer CreateItemFormMsg
    | EditItemFormMsgContainer EditItemFormMsg


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
        ChecklistMsgContainer checklistMsg ->
            handlePageUpdate Pages.ChecklistPage.update ChecklistMsgContainer checklistMsg model

        CreateItemFormMsgContainer createItemMsg ->
            handlePageUpdate Pages.CreateItemPage.update CreateItemFormMsgContainer createItemMsg model

        EditItemFormMsgContainer editItemMsg ->
            handlePageUpdate Pages.EditItemPage.update EditItemFormMsgContainer editItemMsg model



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
                    checklistPageView model.checklist
                        |> Html.Styled.map ChecklistMsgContainer

                CreateItemPage item ->
                    createItemView model item
                        |> Html.Styled.map CreateItemFormMsgContainer

                EditItemPage originalItem item ->
                    editItemView originalItem item model.checklist
                        |> Html.Styled.map EditItemFormMsgContainer
    in
    viewPage model page
