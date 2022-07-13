module ItemModel exposing
    ( IdItemPair
    , Item
    , ItemId
    , ItemStatus(..)
    , decodeItem
    , decodeItemId
    , encodeItem
    , isTicked
    , isUnticked
    , itemId
    , newFakeItem
    , status
    , tick
    , title
    , toggleItem
    , untick
    )

import Json.Decode as D
import Json.Encode as E
import Random
import Random.Char
import Random.String


type alias ItemId =
    String


type Item
    = Item Internals


type ItemStatus
    = Ticked
    | Unticked


type alias Internals =
    { title : String
    , status : ItemStatus
    }


type alias IdItemPair =
    ( ItemId, Item )


newItem : String -> Item
newItem str =
    Item { title = str, status = Unticked }


itemIdGenerator : Random.Generator ItemId
itemIdGenerator =
    Random.String.string 5 Random.Char.english


itemId : Item -> ItemId
itemId (Item item) =
    String.toLower item.title


title : Item -> String
title (Item item) =
    item.title


status : Item -> ItemStatus
status (Item item) =
    item.status


isTicked : Item -> Bool
isTicked (Item item) =
    item.status == Ticked


isUnticked : Item -> Bool
isUnticked (Item item) =
    item.status == Unticked


toggleItem : Item -> Item
toggleItem (Item item) =
    Item
        { item
            | status =
                case item.status of
                    Ticked ->
                        Unticked

                    Unticked ->
                        Ticked
        }


tick : Item -> Item
tick (Item item) =
    Item { item | status = Ticked }


untick : Item -> Item
untick (Item item) =
    Item { item | status = Unticked }


tickedString =
    "ticked"


untickedString =
    "unticked"


encodeItem : Item -> E.Value
encodeItem (Item item) =
    let
        statusString =
            case item.status of
                Ticked ->
                    tickedString

                Unticked ->
                    untickedString
    in
    E.object
        [ ( "title", E.string item.title )
        , ( "status", E.string statusString )
        ]


decodeItemId : String -> Maybe ItemId
decodeItemId s =
    Just s


decodeItemStatus : D.Decoder ItemStatus
decodeItemStatus =
    let
        decodeStatus s =
            if s == untickedString then
                D.succeed Unticked

            else if s == tickedString then
                D.succeed Ticked

            else
                D.fail ("\"" ++ s ++ "\" not recognised as a valid ItemStatus.")
    in
    D.string
        |> D.andThen decodeStatus


decodeItem : D.Decoder Item
decodeItem =
    D.map2 Internals
        (D.field "title" D.string)
        (D.field "status" decodeItemStatus)
        |> D.map Item



-- FOR TESTS


newFakeItem : String -> ItemStatus -> Item
newFakeItem text st =
    Item { title = "TEST - " ++ text, status = st }
