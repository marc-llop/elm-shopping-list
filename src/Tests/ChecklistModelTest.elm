module Tests.ChecklistModelTest exposing (..)

import ChecklistModel exposing (..)
import Expect
import ItemModel exposing (..)
import Model exposing (sortItems)
import Test exposing (..)


suite : Test
suite =
    describe "ChecklistModel"
        [ describe "insert"
            [ test "should insert a new item" <|
                \_ ->
                    let
                        item =
                            newFakeItem "Naps" Unticked

                        dict =
                            empty

                        actual =
                            insert item dict |> toList

                        expected =
                            [ item ]
                    in
                    actual |> Expect.equal expected
            , test "should untick an existing item" <|
                \_ ->
                    let
                        item =
                            newFakeItem "Naps" Ticked

                        dict =
                            fromList [ item ]

                        actual =
                            insert item dict |> toList

                        expected =
                            [ newFakeItem "Naps" Unticked ]
                    in
                    actual |> Expect.equal expected
            , test "should not tick an existing item" <|
                \_ ->
                    let
                        item =
                            newFakeItem "Naps" Ticked

                        dict =
                            fromList [ newFakeItem "Naps" Unticked ]

                        actual =
                            insert item dict |> toList

                        expected =
                            [ newFakeItem "Naps" Unticked ]
                    in
                    actual |> Expect.equal expected
            , test "should do nothing if the item exists, is the same, and is unticked" <|
                \_ ->
                    let
                        item =
                            newFakeItem "Cols" Unticked

                        dict =
                            fromList [ item ]

                        actual =
                            insert item dict |> toList

                        expected =
                            [ item ]
                    in
                    actual |> Expect.equal expected
            , test "should not change the name of an item with that name and different casing" <|
                \_ ->
                    let
                        item =
                            newFakeItem "cols" Ticked

                        dict =
                            fromList [ newFakeItem "Cols" Ticked ]

                        actual =
                            insert item dict |> toList

                        expected =
                            [ newFakeItem "Cols" Unticked ]
                    in
                    actual |> Expect.equal expected
            ]
        , describe "toList"
            [ test "should be symmetric with fromList" <|
                \_ ->
                    let
                        list =
                            [ newFakeItem "Peres" Ticked
                            , newFakeItem "Pomes" Unticked
                            , newFakeItem "Llangonissa" Ticked
                            , newFakeItem "Formatge" Unticked
                            ]

                        dict =
                            fromList list

                        actual =
                            toList dict |> sortItems

                        expected =
                            list |> sortItems
                    in
                    actual |> Expect.equal expected
            ]
        , describe "member"
            [ test "should return true if the item exists with the same name" <|
                \_ ->
                    let
                        checklist =
                            fromList [ newFakeItem "Carbassó" Unticked ]

                        actual =
                            member (newFakeItem "Carbassó" Ticked) checklist

                        expected =
                            True
                    in
                    actual |> Expect.equal expected
            , test "should return true if the item exists with different caps" <|
                \_ ->
                    let
                        checklist =
                            fromList [ newFakeItem "Carbassó" Unticked ]

                        actual =
                            member (newFakeItem "carbassó" Ticked) checklist

                        expected =
                            True
                    in
                    actual |> Expect.equal expected
            , test "should return false if the item exists with different accents" <|
                \_ ->
                    let
                        checklist =
                            fromList [ newFakeItem "Bóta" Unticked ]

                        actual =
                            member (newFakeItem "Bota" Ticked) checklist

                        expected =
                            False
                    in
                    actual |> Expect.equal expected
            , test "should return false if the item does not exist" <|
                \_ ->
                    let
                        checklist =
                            fromList [ newFakeItem "Bóta" Unticked ]

                        actual =
                            member (newFakeItem "Carbassó" Ticked) checklist

                        expected =
                            False
                    in
                    actual |> Expect.equal expected
            ]
        ]
