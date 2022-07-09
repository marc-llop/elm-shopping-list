module Ui.TextInput exposing (ChapterModel, TextInputProps, chapterInitialState, docs, textInputView)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (activeButtonTextColor, glassButtonGlowingBoxShadowColor, inputTextColor, inputTextColorGlow)
import DesignSystem.Colors exposing (..)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow, cardMargins, cardTextShadow, itemFontSize)
import DesignSystem.StyledIcons exposing (blueChevron, blueX)
import ElmBook
import ElmBook.Actions exposing (logAction, updateStateWith)
import ElmBook.Chapter exposing (chapter, renderComponentList, renderStatefulComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, button, div, input)
import Html.Styled.Attributes as HtmlAttr exposing (css)
import Html.Styled.Events as HtmlEvt
import Svg.Styled.Attributes exposing (x)
import Ui.Glassmorphism exposing (glassmorphism)
import Ui.StyleResets exposing (resetButtonStyles)


type alias TextInputProps msg =
    { value : String
    , onInput : String -> msg
    , attributes : List (Html.Styled.Attribute msg)
    }


textInputCardStyles : List Style
textInputCardStyles =
    [ displayFlex
    , width (pct 100)
    , height (px 30)
    , alignItems center
    , borderRadius cardBorderRadius
    , glassmorphism
        { color = accentBlue.s800
        , opacityPct = 0
        , blurPx = 12
        , saturationPct = 0
        }
    , cardBoxShadow (hex glassButtonGlowingBoxShadowColor)
    , cardMargins
    , padding2 (px 5) (px 10)
    , pseudoClass "focus-within"
        [ glassmorphism
            { color = accentBlue.s750
            , opacityPct = 50
            , blurPx = 12
            , saturationPct = 50
            }
        ]
    ]


textInputStyles : List Style
textInputStyles =
    [ displayFlex
    , width (pct 100)
    , fontSize itemFontSize
    , borderStyle none
    , backgroundColor transparent
    , color (hex inputTextColor)
    , cardTextShadow (hex inputTextColorGlow)
    , outline none
    ]


iconOverInputStyle : Style
iconOverInputStyle =
    zIndex (int 1)


widthContainer : List (Html msg) -> Html msg
widthContainer kids =
    div
        [ css [ displayFlex, width (pct 100) ] ]
        kids


textInputView : TextInputProps msg -> Html msg
textInputView { value, onInput, attributes } =
    let
        resetInput =
            onInput ""
    in
    widthContainer
        [ div
            (attributes ++ [ css textInputCardStyles ])
            [ blueChevron iconOverInputStyle
            , input
                [ css textInputStyles
                , HtmlEvt.onInput onInput
                , HtmlAttr.value value
                ]
                []
            , button
                [ css (resetButtonStyles ++ [ displayFlex ]), HtmlEvt.onClick resetInput ]
                [ blueX iconOverInputStyle ]
            ]
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
