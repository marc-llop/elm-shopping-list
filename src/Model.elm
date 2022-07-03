module Model exposing (..)

import ItemModel exposing (..)
import Json.Decode as D
import Json.Encode as E
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..))
import Ui.Item exposing (ItemState(..))


type alias Model =
    { pending : PendingDict
    , done : DoneDict
    , currentPage : Page
    , backgroundTextureUrl : String
    }


type alias PendingDict =
    OpaqueDict ItemId Item


type alias DoneDict =
    OpaqueDict ItemId Item


initModel : String -> PendingDict -> DoneDict -> Model
initModel backgroundTextureUrl pending done =
    { pending = pending
    , done = done
    , currentPage = ListPage
    , backgroundTextureUrl = backgroundTextureUrl
    }


encodeModel : Model -> E.Value
encodeModel model =
    let
        encodeDict =
            OpaqueDict.encode itemIdToString encodeItem
    in
    E.object
        [ ( "pending", encodeDict model.pending )
        , ( "done", encodeDict model.done )
        ]


decodeModel : D.Decoder Model
decodeModel =
    let
        decodeDict =
            OpaqueDict.decode decodeItemIdFromString itemIdToString decodeItem
    in
    D.map3 initModel
        (D.field "backgroundTextureUrl" D.string)
        (D.field "pending" decodeDict)
        (D.field "done" decodeDict)


type alias ItemsInModel a =
    { a | pending : OpaqueDict ItemId Item, done : OpaqueDict ItemId Item }


allNotes : ItemsInModel a -> List IdItemPair
allNotes { pending, done } =
    List.concat
        [ OpaqueDict.toList pending
        , OpaqueDict.toList done
        ]


sortNotes : List IdItemPair -> List IdItemPair
sortNotes =
    List.sortBy (Tuple.second >> .title >> String.toLower)


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
