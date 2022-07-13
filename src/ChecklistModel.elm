module ChecklistModel exposing
    ( Checklist
    , decodeChecklist
    , doneItems
    , empty
    , encodeChecklist
    , filter
    , fromList
    , insert
    , isEmpty
    , pendingItems
    , remove
    , tick
    , toList
    , untick
    , update
    )

{-| An Item Dictionary. This custom type provides two benefits:

  - Its functions do not need IDs nor idToString transformers,
    because the Item already has all the necessary information.
  - It guarantees by construction no two items can share ID.

-}

import Dict exposing (Dict)
import ItemModel exposing (..)
import Json.Decode as D
import Json.Encode as E


type Checklist
    = Checklist (Dict ItemId Item)


empty : Checklist
empty =
    Dict.empty
        |> Checklist



{- Inserts an Item into a dictionary.
   Replaces value when there is a collision.
-}


insert : Item -> Checklist -> Checklist
insert item (Checklist dict) =
    let
        newDict =
            case Dict.get (itemId item) dict of
                Nothing ->
                    Dict.insert (itemId item) item dict

                Just oldItem ->
                    Dict.insert (itemId oldItem) (ItemModel.untick oldItem) dict
    in
    Checklist newDict


tick : ItemId -> Checklist -> Checklist
tick id (Checklist dict) =
    Dict.update id (Maybe.map ItemModel.tick) dict
        |> Checklist


untick : ItemId -> Checklist -> Checklist
untick id (Checklist dict) =
    Dict.update id (Maybe.map ItemModel.untick) dict
        |> Checklist


update : Item -> Checklist -> Checklist
update item (Checklist dict) =
    Dict.update (itemId item) (Maybe.map (always item)) dict
        |> Checklist


remove : ItemId -> Checklist -> Checklist
remove id (Checklist dict) =
    Dict.remove id dict
        |> Checklist


isEmpty : Checklist -> Bool
isEmpty (Checklist dict) =
    Dict.isEmpty dict


fromList : List Item -> Checklist
fromList items =
    let
        itemToKeyValue item =
            ( itemId item, item )
    in
    items
        |> List.map itemToKeyValue
        |> Dict.fromList
        |> Checklist


toList : Checklist -> List Item
toList (Checklist dict) =
    Dict.values dict


filter : (Item -> Bool) -> Checklist -> Checklist
filter predicate (Checklist dict) =
    Dict.filter (\k item -> predicate item) dict
        |> Checklist


pendingItems : Checklist -> List Item
pendingItems itemDict =
    filter isUnticked itemDict |> toList


doneItems : Checklist -> List Item
doneItems itemDict =
    filter isTicked itemDict |> toList


decodeChecklist : D.Decoder Checklist
decodeChecklist =
    D.list decodeItem
        |> D.map fromList


encodeChecklist : Checklist -> E.Value
encodeChecklist itemDict =
    toList itemDict
        |> E.list encodeItem
