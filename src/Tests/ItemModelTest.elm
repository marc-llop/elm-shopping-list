module Tests.ItemModelTest exposing (..)

import Expect
import ItemModel exposing (..)
import Json.Decode as D
import Json.Encode as E
import Test exposing (..)


suite : Test
suite =
    describe "ItemModel"
        [ describe "encode"
            [ test "should be symmetric to decode" <|
                \_ ->
                    let
                        item =
                            newFakeItem "Naps" Unticked

                        encoded =
                            E.encode 0 (encodeItem item)

                        actual =
                            D.decodeString decodeItem encoded

                        expected =
                            Ok item
                    in
                    actual |> Expect.equal expected
            ]
        ]
