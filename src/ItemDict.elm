module ItemDict exposing (ItemDict)

{-| An Item Dictionary. This custom type provides two benefits:

  - Its functions do not need IDs nor idToString transformers,
    because the Item already has all the necessary information.
  - It guarantees by construction no two items can share ID.

-}

import ItemModel exposing (Item, ItemId, itemToId)
import Json.Decode as D
import Json.Encode as E
import OpaqueDict exposing (OpaqueDict)


type ItemDict
    = ItemDict (OpaqueDict ItemId Item)


empty : ItemDict
empty =
    OpaqueDict.empty itemToId
        |> ItemDict



{- Inserts an Item into a dictionary.
   Replaces value when there is a collision.
-}


insert : Item -> ItemDict -> ItemDict
insert item (ItemDict dict) =
    OpaqueDict.insert itemToId item dict
        |> ItemDict


update :
    ItemId
    -> (Maybe Item -> Maybe Item)
    -> ItemDict
    -> ItemDict
update id fn (ItemDict dict) =
    OpaqueDict.update id fn dict
        |> ItemDict


remove : ItemId -> ItemDict -> ItemDict
remove id (ItemDict dict) =
    OpaqueDict.remove id dict
        |> ItemDict


isEmpty : ItemDict -> Bool
isEmpty (ItemDict dict) =
    OpaqueDict.isEmpty dict


fromList : List Item -> ItemDict
fromList items =
    OpaqueDict.fromList itemToId
        |> ItemDict


toList : ItemDict -> List Item
toList (ItemDict dict) =
    OpaqueDict.values dict


filter : (Item -> Bool) -> ItemDict -> ItemDict
filter predicate (ItemDict dict) =
    OpaqueDict.filter (\k item -> predicate item) dict
        |> ItemDict


pendingItems : ItemDict -> List Item
pendingItems itemDict =
    filter isPending itemDict |> toList


doneItems : ItemDict -> List Item
doneItems itemDict =
    filter isDone itemDict |> toList


decode : D.Decoder ItemDict
decode =
    D.list decodeItem
        |> D.map fromList


encode : ItemDict -> E.Value
encode itemDict =
    toList itemDict
        |> E.list encodeItem
