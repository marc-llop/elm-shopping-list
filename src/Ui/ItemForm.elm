module Ui.ItemForm exposing (ItemFormProps, ItemFormType(..), Msg(..), docs, itemFormView)

import Css exposing (displayFlex, pct, px)
import DesignSystem.Sizes exposing (formHeight)
import ElmBook
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onSubmit)
import Ui.Button exposing (ButtonType(..))
import Ui.TextInput exposing (textInputView)
import Utils exposing (dataTestId)


type alias ItemFormProps =
    { dataTestId : String
    , autoFocusId : String
    , value : String
    , formType : ItemFormType
    }


type alias ItemExists =
    Bool


type alias OriginalValue =
    String


type ItemFormType
    = CreateItem
    | EditItem ItemExists OriginalValue


type Msg
    = Input String
    | Submit
    | Cancel


submitButtonLabel : ItemFormType -> String
submitButtonLabel formType =
    case formType of
        CreateItem ->
            "Afegeix l'element"

        EditItem _ _ ->
            "Desa els canvis"


isSubmitEnabled : ItemFormProps -> Bool
isSubmitEnabled { value, formType } =
    let
        hasContent =
            not (String.isEmpty value)

        hasChangedFrom original =
            value /= original
    in
    case formType of
        CreateItem ->
            hasContent

        EditItem itemExists originalValue ->
            hasContent && hasChangedFrom originalValue && not itemExists


hasError : ItemFormType -> Bool
hasError formType =
    case formType of
        CreateItem ->
            False

        EditItem itemExists _ ->
            itemExists


itemFormView : ItemFormProps -> Html Msg
itemFormView props =
    Html.Styled.form
        [ onSubmit Submit
        , dataTestId props.dataTestId
        , css formStyles
        ]
        [ textInputView
            { onInput = Input
            , value = props.value
            , attributes =
                [ id props.autoFocusId
                , dataTestId (props.dataTestId ++ "++TextInput")
                ]
            , hasError = hasError props.formType
            }
        , div
            [ css buttonRowStyles ]
            [ Ui.Button.button
                { buttonType = Ui.Button.Button Cancel
                , label = "Cancel·la"
                , isEnabled = True
                }
            , Ui.Button.button
                { buttonType = Ui.Button.Submit
                , label = submitButtonLabel props.formType
                , isEnabled = isSubmitEnabled props
                }
            ]
        ]


formStyles =
    [ Css.width (pct 100)
    , Css.height formHeight
    , displayFlex
    , Css.flexDirection Css.column
    ]


buttonRowStyles =
    [ displayFlex
    , Css.height (pct 100)
    , Css.property "column-gap" "10%"
    , Css.justifyContent Css.center
    , Css.paddingTop (px 25)
    , Css.paddingBottom (px 30)
    ]



-- DOCS


docs : Chapter x
docs =
    let
        props =
            { dataTestId = ""
            , autoFocusId = ""
            , value = "Carrot"
            , formType = EditItem False "Carrot"
            }

        mapMessage msg =
            case msg of
                Input s ->
                    logAction ("\"" ++ s ++ "\" inputted")

                Submit ->
                    logAction "Submitted"

                Cancel ->
                    logAction "Cancelled"

        chapterItemFormView p =
            Html.Styled.map mapMessage (itemFormView p)
    in
    chapter "ItemForm"
        |> renderComponentList
            [ ( "EditItemForm with no changes", chapterItemFormView props )
            , ( "EditItemForm with changes", chapterItemFormView { props | value = "Carrots", formType = EditItem False "Carrot" } )
            , ( "EditItemForm with error", chapterItemFormView { props | value = "Raddish", formType = EditItem True "Carrot" } )
            , ( "CreateItemForm", chapterItemFormView { props | formType = CreateItem } )
            , ( "CreateItemForm empty", chapterItemFormView { props | value = "", formType = CreateItem } )
            ]
