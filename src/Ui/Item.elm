module Ui.Item exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (..)
import DesignSystem.Colors exposing (accentBlue, backgroundPurple, neutral)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow, cardMargins, cardTextShadow, itemFontSize)
import DesignSystem.StyledIcons exposing (blueEdit, greenPlus, redTrash, tickedCheck, untickedCheck)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import ItemModel exposing (Item, ItemId, ItemStatus(..), itemId, newFakeItem)
import Json.Decode
import Ui.Glassmorphism exposing (glassmorphism)
import Ui.StyleResets exposing (resetButtonStyles)
import Utils exposing (dataTestId, transparencyBackground)


type ItemState msg
    = Pending (WriteEvents msg)
    | Done (WriteEvents msg)
    | ToAdd -- Used in CreateItem search


type alias WriteEvents msg =
    { onRemove : ItemId -> msg
    , onEdit : ItemId -> Item -> msg
    }


type alias ItemProps msg =
    { item : Item
    , state : ItemState msg
    , onTick : ItemId -> msg
    }


checkboxView : ItemState msg -> Html msg
checkboxView state =
    case state of
        Pending _ ->
            untickedCheck

        Done _ ->
            tickedCheck

        ToAdd ->
            greenPlus


iconButtonView evt icon =
    button
        [ onClickStopPropagation evt
        , css resetButtonStyles
        ]
        [ icon ]


itemView : ItemProps msg -> Html msg
itemView { item, state, onTick } =
    let
        writeButtonElems { onEdit, onRemove } =
            [ iconButtonView (onRemove (itemId item)) redTrash
            , iconButtonView (onEdit (itemId item) item) blueEdit
            ]

        writeButtons =
            case state of
                Pending we ->
                    writeButtonElems we

                Done we ->
                    writeButtonElems we

                ToAdd ->
                    []
    in
    li
        [ dataTestId (stateToDataTestId state)
        , css (itemStyle state)
        , onClick (onTick (itemId item))
        ]
        ([ checkboxView state
         , span [ css [ itemTitleStyle ] ] [ text (ItemModel.title item) ]
         ]
            ++ writeButtons
        )


stateToDataTestId : ItemState msg -> String
stateToDataTestId state =
    case state of
        Pending _ ->
            "ListedItemPending"

        Done _ ->
            "ListedItemDone"

        ToAdd ->
            "MatchedItem"


onClickStopPropagation : msg -> Attribute msg
onClickStopPropagation msg =
    stopPropagationOn "click" <| Json.Decode.succeed ( msg, True )


itemStyle : ItemState msg -> List Style
itemStyle state =
    let
        { glassColor, glassOpacity, glassBlur, boxShadowColor, textColor, textShadowColor } =
            case state of
                Pending _ ->
                    { glassColor = neutralCardColor.color
                    , glassOpacity = neutralCardColor.opacityPct
                    , glassBlur = neutralCardColor.blurPx
                    , boxShadowColor = neutralCardBoxShadowColor
                    , textColor = neutralTextColor
                    , textShadowColor = neutralCardTextShadowColor
                    }

                Done _ ->
                    { glassColor = backgroundPurple.s750
                    , glassOpacity = 30
                    , glassBlur = 10
                    , boxShadowColor = backgroundPurple.s650
                    , textColor = backgroundPurple.s200
                    , textShadowColor = backgroundPurple.s400
                    }

                ToAdd ->
                    { glassColor = glassButtonInertColor.color
                    , glassOpacity = glassButtonInertColor.opacityPct
                    , glassBlur = glassButtonInertColor.blurPx
                    , boxShadowColor = glassButtonInertBoxShadowColor
                    , textColor = accentBlue.s300
                    , textShadowColor = accentBlue.s400
                    }
    in
    [ resetLiStyle
    , glassmorphism
        { color = glassColor
        , opacityPct = glassOpacity
        , blurPx = glassBlur
        , saturationPct = 100
        }
    , displayFlex
    , alignItems center
    , justifyContent spaceBetween
    , Css.height (px 60)
    , paddingLeft (px 15)
    , paddingRight (px 15)
    , cardMargins
    , borderRadius cardBorderRadius
    , cardBoxShadow (hex boxShadowColor)
    , cardTextShadow (hex textShadowColor)
    , fontSize itemFontSize
    , color (hex textColor)
    , cursor pointer
    , hover
        (if state == ToAdd then
            [ glassmorphism glassButtonGlowingColor ]

         else
            []
        )
    ]


resetLiStyle : Style
resetLiStyle =
    listStyle none


itemTitleStyle : Style
itemTitleStyle =
    Css.batch
        [ flexGrow (int 1)
        , marginLeft (px 20)
        ]


docs : Chapter x
docs =
    let
        writeEvents =
            { onRemove = \_ -> logAction "Removed"
            , onEdit = \_ _ -> logAction "Edit clicked"
            }

        fakeItem =
            newFakeItem "Milk" Unticked

        props =
            { item = fakeItem
            , state = Pending writeEvents
            , onTick = \_ -> logAction "Ticked"
            }

        showcaseItem p =
            transparencyBackground
                { width = 650, height = 80 }
                (itemView p)
    in
    chapter "Item"
        |> renderComponentList
            [ ( "Pending", showcaseItem props )
            , ( "Done", showcaseItem { props | state = Done writeEvents, onTick = \_ -> logAction "Unticked" } )
            , ( "ToAdd", showcaseItem { props | state = ToAdd, onTick = \_ -> logAction "Added item" } )
            ]
