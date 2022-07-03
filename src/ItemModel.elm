module ItemModel exposing (IdItemPair, Item, ItemId, decodeItem, decodeItemIdFromString, encodeItem, itemIdGenerator, itemIdToString, newFakeItem)

import Json.Decode as D
import Json.Encode as E
import Random
import Random.Char
import Random.String


type ItemId
    = ItemId String


itemIdToString : ItemId -> String
itemIdToString (ItemId id) =
    id


itemIdGenerator : Random.Generator ItemId
itemIdGenerator =
    Random.String.string 5 Random.Char.english
        |> Random.map ItemId


decodeItemId : D.Decoder ItemId
decodeItemId =
    D.map ItemId D.string


decodeItemIdFromString : String -> Maybe ItemId
decodeItemIdFromString s =
    Just (ItemId s)


newFakeItem : Int -> String -> IdItemPair
newFakeItem id title =
    ( ItemId (String.fromInt id), { title = title } )


type alias Item =
    { title : String
    }


encodeItem : Item -> E.Value
encodeItem { title } =
    E.string title


decodeItem : D.Decoder Item
decodeItem =
    D.map Item D.string


type alias IdItemPair =
    ( ItemId, Item )
