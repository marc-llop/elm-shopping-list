module Ui.TextInput exposing (ChapterModel, TextInputProps, chapterInitialState, docs, textInputView)

import Css exposing (..)
import Css.Transitions exposing (easeOut, transition)
import DesignSystem.ColorDecisions exposing (activeButtonTextColor, glassButtonGlowingBoxShadowColor)
import DesignSystem.Colors exposing (..)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow, itemFontSize)
import ElmBook
import ElmBook.Actions exposing (logAction, updateStateWith)
import ElmBook.Chapter exposing (chapter, renderComponentList, renderStatefulComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, input)
import Html.Styled.Attributes as HtmlAttr exposing (css)
import Html.Styled.Events as HtmlEvt
import Svg.Styled.Attributes exposing (x)
import Ui.Glassmorphism exposing (glassmorphism)


type alias TextInputProps msg =
    { value : String
    , onInput : String -> msg
    , attributes : List (Html.Styled.Attribute msg)
    }


textInputStyles : List Style
textInputStyles =
    [ displayFlex
    , width (pct 100)
    , height (px 30)
    , padding2 (px 5) (px 5)
    , textIndent (px 5)
    , fontSize itemFontSize
    , borderRadius cardBorderRadius
    , borderStyle none
    , glassmorphism
        { color = accentBlue.s800
        , opacityPct = 0
        , blurPx = 12
        , saturationPct = 0
        }
    , cardBoxShadow (hex glassButtonGlowingBoxShadowColor)
    , color (hex accentBlue.s200)
    , textShadow4 zero zero (px 3) (hex accentBlue.s300)
    ]


textInputView : TextInputProps msg -> Html msg
textInputView { value, onInput, attributes } =
    input
        (attributes
            ++ [ css textInputStyles
               , HtmlEvt.onInput onInput
               , HtmlAttr.value value
               ]
        )
        []



-- DOCS


type alias ChapterModel =
    String


type alias SharedState x =
    { x | textInputModel : ChapterModel }


chapterInitialState : ChapterModel
chapterInitialState =
    ""


updateChapterState : String -> SharedState x -> SharedState x
updateChapterState val x =
    { x | textInputModel = val }


docs : Chapter (SharedState x)
docs =
    let
        props =
            { value = ""
            , onInput = \s -> logAction ("inputted: " ++ s)
            }
    in
    chapter "TextInput"
        |> renderStatefulComponent
            (\{ textInputModel } ->
                textInputView
                    { value = textInputModel
                    , onInput = updateStateWith updateChapterState
                    , attributes = []
                    }
            )
