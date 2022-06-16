module Tests.NoteTest exposing (..)

import Expect exposing (Expectation)
import OpaqueDict
import Test exposing (..)
import Ui.Glassmorphism exposing (percentToHex)


suite : Test
suite =
    describe "Glassmorphism"
        [ describe "percentToHex"
            [ test "should return 100 as ff" <|
                \_ ->
                    percentToHex 100 |> Expect.equal "ff"
            , test "should return 0 as 00" <|
                \_ -> percentToHex 0 |> Expect.equal "00"
            , test "should return 25 as 3f" <|
                \_ -> percentToHex 25 |> Expect.equal "3f"
            , test "should clamp negative numbers" <|
                \_ -> percentToHex -200 |> Expect.equal "00"
            , test "should clamp numbers higher than 100" <|
                \_ -> percentToHex 101 |> Expect.equal "ff"
            ]
        ]
