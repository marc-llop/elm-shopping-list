module NamedInterpolate exposing (interpolate)

import Char
import Debug
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


replace : Dict String String -> Token -> String
replace dict t =
    case t of
        Text s ->
            s

        Variable v ->
            Dict.get v dict |> Maybe.withDefault ("{" ++ v ++ "}")


tokensToStrings : Dict String String -> Template -> List String
tokensToStrings dict tokens =
    List.map (replace dict) tokens


interpolate : String -> List ( String, String ) -> String
interpolate template values =
    let
        dict =
            Dict.fromList values

        tokenizedTemplate =
            run parseTemplate template
    in
    tokenizedTemplate
        |> Result.map (tokensToStrings dict)
        |> Result.map String.concat
        |> Result.withDefault template
