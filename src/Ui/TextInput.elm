module Ui.TextInput exposing (ChapterModel, TextInputProps, chapterInitialState, docs, textInputView)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (activeButtonTextColor, glassButtonGlowingBoxShadowColor, inputTextColor, inputTextColorGlow)
import DesignSystem.Colors exposing (..)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow, cardMargins, cardTextShadow, itemFontSize)
import DesignSystem.StyledIcons exposing (blueChevron)
import ElmBook
import ElmBook.Actions exposing (logAction, updateStateWith)
import ElmBook.Chapter exposing (chapter, renderComponentList, renderStatefulComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, div, input)
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
    , cardMargins
    , textIndent (px 30)
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
    , color (hex inputTextColor)
    , cardTextShadow (hex inputTextColorGlow)
    ]


type IconAlignment
    = Left
    | Right


iconOverInputStyle : IconAlignment -> Style
iconOverInputStyle alignment =
    [ position absolute
    , zIndex (int 1)
    , top (px 5)
    , (case alignment of
        Left ->
            left

        Right ->
            right
      )
        (px 10)
    ]
        |> Css.batch


textInputView : TextInputProps msg -> Html msg
textInputView { value, onInput, attributes } =
    div
        [ css [ displayFlex, width (pct 100) ] ]
        [ blueChevron (iconOverInputStyle Left)
        , input
            (attributes
                ++ [ css textInputStyles
                   , HtmlEvt.onInput onInput
                   , HtmlAttr.value value
                   ]
            )
            []
        ]



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
