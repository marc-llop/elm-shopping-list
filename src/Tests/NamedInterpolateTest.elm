module Tests.NamedInterpolateTest exposing (..)

import Expect exposing (Expectation)
import NamedInterpolate exposing (interpolate)
import Parser exposing (Problem(..))
import Test exposing (..)


suite : Test
suite =
    describe "NamedInterpolate"
        [ describe "interpolate"
            [ test "should replace the tags in the string with the provided values" <|
                \_ ->
                    let
                        template =
                            "Hello {name}! So you are {age} years old already?"

                        values =
                            [ ( "name", "Pepet" ), ( "age", "42" ) ]

                        actual =
                            interpolate template values

                        expected =
                            Ok "Hello Pepet! So you are 42 years old already?"
                    in
                    actual |> Expect.equal expected
            , test "should replace the tags no matter the order" <|
                \_ ->
                    let
                        template =
                            "margin: {margin}px; padding: {padding}px;"

                        values =
                            [ ( "padding", "5" ), ( "margin", "15" ) ]

                        actual =
                            interpolate template values

                        expected =
                            Ok "margin: 15px; padding: 5px;"
                    in
                    actual |> Expect.equal expected
            , test "should be resilient to extra and repeated values" <|
                \_ ->
                    let
                        template =
                            "margin: {margin}px; padding: {padding}px;"

                        values =
                            [ ( "padding", "5" ), ( "margin", "15" ), ( "margin", "20" ), ( "borderWidth", "3" ) ]

                        actual =
                            interpolate template values

                        expected =
                            Ok "margin: 20px; padding: 5px;"
                    in
                    actual |> Expect.equal expected
            , test "should return error if a variable is missing in values" <|
                \_ ->
                    let
                        template =
                            "margin: {margin}px; padding: {padding}px;"

                        values =
                            [ ( "padding", "5" ) ]

                        actual =
                            interpolate template values

                        expected =
                            Err [ NamedInterpolate.VarNotFound "margin" ]
                    in
                    actual |> Expect.equal expected
            , test "should return parser errors if the template can not be parsed" <|
                \_ ->
                    let
                        template =
                            "margin: {margin{}}px; padding: {paddingpx;"

                        values =
                            [ ( "padding", "5" ), ( "margin", "15" ) ]

                        actual =
                            interpolate template values

                        expected =
                            Err [ NamedInterpolate.DeadEnd { col = 16, row = 1, problem = ExpectingSymbol "}" } ]
                    in
                    actual |> Expect.equal expected
            ]
        ]
