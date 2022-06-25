module Tests.CreateNoteTest exposing (..)

import CreateNotePage exposing (notesMatching)
import Expect
import Note exposing (Note, NoteId(..), NoteIdPair, newFakeNote, noteIdToString)
import OpaqueDict exposing (OpaqueDict)
import Test exposing (..)


dict : List NoteIdPair -> OpaqueDict NoteId Note
dict ls =
    OpaqueDict.fromList noteIdToString ls


suite : Test
suite =
    describe "CreateNote"
        [ describe "notesMatching"
            [ test "should return all the notes for empty string, sorted alphabetically" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeNote 1 "Eggs", newFakeNote 2 "Milk" ]
                            , done = dict [ newFakeNote 3 "Frozen pizza" ]
                            }

                        actual =
                            notesMatching "" model

                        expected =
                            [ newFakeNote 1 "Eggs"
                            , newFakeNote 3 "Frozen pizza"
                            , newFakeNote 2 "Milk"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return all the notes that contain the string" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeNote 1 "Tomatoes", newFakeNote 2 "Tuna" ]
                            , done = dict [ newFakeNote 3 "Toasts", newFakeNote 4 "Potatoes" ]
                            }

                        actual =
                            notesMatching "toes" model

                        expected =
                            [ newFakeNote 4 "Potatoes"
                            , newFakeNote 1 "Tomatoes"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should not be case sensitive" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeNote 1 "Tomatoes", newFakeNote 2 "Tuna" ]
                            , done = dict [ newFakeNote 3 "Toasts", newFakeNote 4 "Rice" ]
                            }

                        actual =
                            notesMatching "to" model

                        expected =
                            [ newFakeNote 3 "Toasts"
                            , newFakeNote 1 "Tomatoes"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should return matches ignoring accents in search query and in notes" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeNote 1 "Arròs" ]
                            , done = dict [ newFakeNote 2 "Postres", newFakeNote 3 "Fuet" ]
                            }

                        actual =
                            notesMatching "ós" model

                        expected =
                            [ newFakeNote 1 "Arròs"
                            , newFakeNote 2 "Postres"
                            ]
                    in
                    actual |> Expect.equal expected
            , test "should normalize other characters" <|
                \_ ->
                    let
                        model =
                            { pending = dict [ newFakeNote 1 "Llet", newFakeNote 2 "Pa" ]
                            , done = dict [ newFakeNote 3 "Cola", newFakeNote 4 "Formatge", newFakeNote 5 "Calçots" ]
                            }

                        actual =
                            notesMatching "ço" model

                        expected =
                            [ newFakeNote 5 "Calçots"
                            , newFakeNote 3 "Cola"
                            ]
                    in
                    actual |> Expect.equal expected
            ]
        ]
