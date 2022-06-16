module Tests.CreateNoteTest exposing (..)

import CreateNote exposing (notesMatching)
import Expect exposing (Expectation)
import Note exposing (Note, NoteId(..), intToNoteId, noteIdToString)
import OpaqueDict exposing (OpaqueDict)
import Test exposing (..)


intDictFrom : List ( Int, String ) -> OpaqueDict NoteId Note
intDictFrom list =
    list
        |> List.map (\( id, s ) -> ( intToNoteId id, { title = s } ))
        |> OpaqueDict.fromList noteIdToString


suite : Test
suite =
    describe "CreateNote"
        [ describe "notesMatching"
            [ test "should return all the notes for empty string" <|
                \_ ->
                    let
                        model =
                            { pending = intDictFrom [ ( 1, "Eggs" ), ( 2, "Milk" ) ]
                            , done = intDictFrom [ ( 3, "Frozen pizza" ) ]
                            }

                        actual =
                            notesMatching "" model

                        expected =
                            [ ( NoteId "1", { title = "Eggs" } )
                            , ( NoteId "2", { title = "Milk" } )
                            , ( NoteId "3", { title = "Frozen pizza" } )
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return all the notes that contain the string" <|
                \_ ->
                    let
                        model =
                            { pending = intDictFrom [ ( 1, "Tomatoes" ), ( 2, "Tuna" ) ]
                            , done = intDictFrom [ ( 3, "Toasts" ), ( 4, "Potatoes" ) ]
                            }

                        actual =
                            notesMatching "toes" model

                        expected =
                            [ ( NoteId "1", { title = "Tomatoes" } )
                            , ( NoteId "4", { title = "Potatoes" } )
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should not be case sensitive" <|
                \_ ->
                    let
                        model =
                            { pending = intDictFrom [ ( 1, "Tomatoes" ), ( 2, "Tuna" ) ]
                            , done = intDictFrom [ ( 3, "Toasts" ), ( 4, "Rice" ) ]
                            }

                        actual =
                            notesMatching "to" model

                        expected =
                            [ ( NoteId "1", { title = "Tomatoes" } )
                            , ( NoteId "3", { title = "Toasts" } )
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return matches ignoring accents in search query and in notes" <|
                \_ ->
                    let
                        model =
                            { pending = intDictFrom [ ( 1, "Arròs" ) ]
                            , done = intDictFrom [ ( 2, "Postres" ), ( 3, "Fuet" ) ]
                            }

                        actual =
                            notesMatching "ós" model

                        expected =
                            [ ( NoteId "1", { title = "Arròs" } )
                            , ( NoteId "2", { title = "Postres" } )
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should normalize other characters" <|
                \_ ->
                    let
                        model =
                            { pending = intDictFrom [ ( 1, "Llet" ), ( 2, "Pa" ) ]
                            , done = intDictFrom [ ( 3, "Cola" ), ( 4, "Formatge" ), ( 5, "Calçots" ) ]
                            }

                        actual =
                            notesMatching "ço" model

                        expected =
                            [ ( NoteId "3", { title = "Cola" } )
                            , ( NoteId "5", { title = "Calçots" } )
                            ]
                    in
                    actual |> Expect.equal expected
            ]
        ]
