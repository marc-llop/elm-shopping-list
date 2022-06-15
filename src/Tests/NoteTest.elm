module Tests.NoteTest exposing (..)

import Expect exposing (Expectation)
import Note
import OpaqueDict
import Test exposing (..)


suite : Test
suite =
    describe "Note"
        [ describe "percentToHex"
            [ test "should return 100 as ff" <|
                \_ ->
                    Note.percentToHex 100 |> Expect.equal "ff"
            , test "should return 0 as 00" <|
                \_ -> Note.percentToHex 0 |> Expect.equal "00"
            , test "should return 25 as 3f" <|
                \_ -> Note.percentToHex 25 |> Expect.equal "3f"
            , test "should clamp negative numbers" <|
                \_ -> Note.percentToHex -200 |> Expect.equal "00"
            , test "should clamp numbers higher than 100" <|
                \_ -> Note.percentToHex 101 |> Expect.equal "ff"
            ]
        ]
