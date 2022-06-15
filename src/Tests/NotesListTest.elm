module Tests.NotesListTest exposing (..)

import Expect exposing (Expectation)
import Model
import OpaqueDict
import Test exposing (..)


intDictFrom =
    OpaqueDict.fromList String.fromInt


suite : Test
suite =
    describe "NotesList"
        [ describe "move"
            [ test "should move an element from one dictionary to an empty one" <|
                \_ ->
                    let
                        dictA =
                            intDictFrom [ ( 4, "a" ), ( 2, "b" ), ( 42, "x" ) ]

                        dictB =
                            intDictFrom []

                        expectedA =
                            intDictFrom [ ( 4, "a" ), ( 42, "x" ) ]

                        expectedB =
                            intDictFrom [ ( 2, "b" ) ]

                        actual =
                            Model.move 2 dictA dictB
                    in
                    actual |> Expect.equal ( expectedA, expectedB )
            , test "should move an element to a non-empty dictionary" <|
                \_ ->
                    let
                        dictA =
                            intDictFrom [ ( 4, "a" ), ( 2, "b" ), ( 42, "x" ) ]

                        dictB =
                            intDictFrom [ ( 3, "e" ), ( 5, "f" ) ]

                        expectedA =
                            intDictFrom [ ( 4, "a" ), ( 2, "b" ) ]

                        expectedB =
                            intDictFrom [ ( 3, "e" ), ( 5, "f" ), ( 42, "x" ) ]

                        actual =
                            Model.move 42 dictA dictB
                    in
                    actual |> Expect.equal ( expectedA, expectedB )
            , test "should do nothing if element is not in origin" <|
                \_ ->
                    let
                        dictA =
                            intDictFrom []

                        dictB =
                            intDictFrom [ ( 2, "a" ) ]

                        actual =
                            Model.move 42 dictA dictB
                    in
                    actual |> Expect.equal ( dictA, dictB )
            ]
        ]
