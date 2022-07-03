module Tests.CreateItemTest exposing (..)

import CreateItemPage exposing (itemsMatching)
import Expect
import ItemModel exposing (IdItemPair, Item, ItemId(..), itemIdToString, newFakeItem)
import OpaqueDict exposing (OpaqueDict)
import Test exposing (..)


dict : List IdItemPair -> OpaqueDict ItemId Item
dict ls =
    OpaqueDict.fromList itemIdToString ls


suite : Test
suite =
    describe "CreateItem"
        [ describe "itemsMatching"
            [ test "should return all the items for empty string, sorted alphabetically" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeItem 1 "Eggs", newFakeItem 2 "Milk" ]
                            , done = dict [ newFakeItem 3 "Frozen pizza" ]
                            }

                        actual =
                            itemsMatching "" model

                        expected =
                            [ newFakeItem 1 "Eggs"
                            , newFakeItem 3 "Frozen pizza"
                            , newFakeItem 2 "Milk"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return all the items that contain the string" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeItem 1 "Tomatoes", newFakeItem 2 "Tuna" ]
                            , done = dict [ newFakeItem 3 "Toasts", newFakeItem 4 "Potatoes" ]
                            }

                        actual =
                            itemsMatching "toes" model

                        expected =
                            [ newFakeItem 4 "Potatoes"
                            , newFakeItem 1 "Tomatoes"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should not be case sensitive" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeItem 1 "Tomatoes", newFakeItem 2 "Tuna" ]
                            , done = dict [ newFakeItem 3 "Toasts", newFakeItem 4 "Rice" ]
                            }

                        actual =
                            itemsMatching "to" model

                        expected =
                            [ newFakeItem 3 "Toasts"
                            , newFakeItem 1 "Tomatoes"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return matches ignoring accents in search query and in items" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeItem 1 "Arròs" ]
                            , done = dict [ newFakeItem 2 "Postres", newFakeItem 3 "Fuet" ]
                            }

                        actual =
                            itemsMatching "ós" model

                        expected =
                            [ newFakeItem 1 "Arròs"
                            , newFakeItem 2 "Postres"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should normalize other characters" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeItem 1 "Llet", newFakeItem 2 "Pa" ]
                            , done = dict [ newFakeItem 3 "Cola", newFakeItem 4 "Formatge", newFakeItem 5 "Calçots" ]
                            }

                        actual =
                            itemsMatching "ço" model

                        expected =
                            [ newFakeItem 5 "Calçots"
                            , newFakeItem 3 "Cola"
                            ]
                    in
                    actual |> Expect.equal expected
            ]
        ]
