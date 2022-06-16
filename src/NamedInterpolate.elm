module NamedInterpolate exposing (Error(..), interpolate)

import Char
import Dict exposing (Dict, foldr)
import Parser exposing ((|.), (|=), Parser, Step(..), end, loop, map, oneOf, run, succeed, symbol, variable)
import Set exposing (Set)
import Svg.Styled exposing (tspan)


type Token
    = Text String
    | Variable String


type alias Template =
    List Token


type alias Predicate a =
    a -> Bool


both : Predicate a -> Predicate a -> Predicate a
both px py a =
    px a && py a


parseVariable : Parser Token
parseVariable =
    succeed Variable
        |. symbol "{"
        |= variable
            { start = both Char.isAlpha Char.isLower
            , inner = Char.isAlphaNum
            , reserved = Set.empty
            }
        |. symbol "}"


notOpenBracket : Char -> Bool
notOpenBracket c =
    c /= '{'


parseText : Parser Token
parseText =
    succeed Text
        |= variable
            { start = notOpenBracket
            , inner = notOpenBracket
            , reserved = Set.empty
            }


parseVariableOrText : Parser Token
parseVariableOrText =
    oneOf [ parseVariable, parseText ]


parseTemplate : Parser Template
parseTemplate =
    loop [] parseLoop


parseLoop : Template -> Parser (Parser.Step Template Template)
parseLoop tokens =
    oneOf
        [ end |> map (\_ -> Done tokens)
        , parseVariableOrText |> map (\token -> Loop (tokens ++ [ token ]))
        ]


type Error
    = DeadEnd Parser.DeadEnd
    | VarNotFound String


replace : Dict String String -> Token -> Result Error String
replace dict t =
    case t of
        Text s ->
            Ok s

        Variable v ->
            Dict.get v dict |> Result.fromMaybe (VarNotFound v)


foldResult : Result a b -> Result (List a) (List b) -> Result (List a) (List b)
foldResult res acc =
    case ( res, acc ) of
        ( Ok x, Ok xs ) ->
            Ok (xs ++ [ x ])

        ( Err x, Err xs ) ->
            Err (xs ++ [ x ])

        ( Ok _, Err xs ) ->
            Err xs

        ( Err x, Ok _ ) ->
            Err [ x ]


tokensToStrings : Dict String String -> Template -> Result (List Error) (List String)
tokensToStrings dict tokens =
    tokens
        |> List.map (replace dict)
        |> List.foldl foldResult (Ok [])


interpolate : String -> List ( String, String ) -> Result (List Error) String
interpolate template values =
    let
        dict =
            Dict.fromList values

        tokenizedTemplate =
            run parseTemplate template
    in
    tokenizedTemplate
        |> Result.mapError (List.map DeadEnd)
        |> Result.andThen (tokensToStrings dict)
        |> Result.map String.concat
