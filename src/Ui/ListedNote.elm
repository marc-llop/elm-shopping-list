module Ui.ListedNote exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (neutralTextColor)
import DesignSystem.Colors exposing (accentBlue, backgroundPurple, neutral)
import DesignSystem.StyledIcons exposing (blueEdit, greenPlus, redTrash, tickedCheck, untickedCheck)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import Json.Decode
import Note exposing (Note, NoteId)
import Ui.Glassmorphism exposing (glassmorphism)
import Utils exposing (dataTestId, transparencyBackground)


type NoteState
    = Pending
    | Done
    | ToAdd -- Used in CreateNote search


type alias ListedNoteProps msg =
    { noteId : NoteId
    , note : Note
    , state : NoteState
    , onTick : NoteId -> msg
    , onRemove : NoteId -> msg
    , onEdit : NoteId -> Note -> msg
    }


checkboxView : NoteState -> Html msg
checkboxView state =
    case state of
        Pending ->
            untickedCheck

        Done ->
            tickedCheck

        ToAdd ->
            greenPlus


resetButtonStyles : List Style
resetButtonStyles =
    [ borderStyle none
    , backgroundColor transparent
    , cursor pointer
    ]


iconButtonView evt icon =
    button
        [ onClickStopPropagation evt
        , css resetButtonStyles
        ]
        [ icon ]


listedNoteView : ListedNoteProps msg -> Html msg
listedNoteView { noteId, note, state, onTick, onRemove, onEdit } =
    li [ dataTestId "ListedNote", css (noteStyle state), onClick (onTick noteId) ]
        [ checkboxView state
        , span [ css [ noteTitleStyle ] ] [ text note.title ]
        , iconButtonView (onRemove noteId) redTrash
        , iconButtonView (onEdit noteId note) blueEdit
        ]


onClickStopPropagation : msg -> Attribute msg
onClickStopPropagation msg =
    stopPropagationOn "click" <| Json.Decode.succeed ( msg, True )


noteStyle : NoteState -> List Style
noteStyle state =
    let
        { glassColor, glassOpacity, glassBlur, boxShadowColor, textColor, textShadowColor } =
            case state of
                Pending ->
                    { glassColor = neutral.s750
                    , glassOpacity = 35
                    , glassBlur = 6
                    , boxShadowColor = neutral.s750
                    , textColor = neutralTextColor
                    , textShadowColor = neutral.s500
                    }

                Done ->
                    { glassColor = backgroundPurple.s750
                    , glassOpacity = 30
                    , glassBlur = 10
                    , boxShadowColor = backgroundPurple.s650
                    , textColor = backgroundPurple.s200
                    , textShadowColor = backgroundPurple.s400
                    }

                ToAdd ->
                    { glassColor = accentBlue.s500
                    , glassOpacity = 15
                    , glassBlur = 13
                    , boxShadowColor = accentBlue.s800
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
    , margin4 (px 3) (px 7) (px 5) (px 5)
    , borderRadius (px 10)
    , boxShadow3 (px 2) (px 2) (hex boxShadowColor)
    , fontSize (rem 1.2)
    , color (hex textColor)
    , textShadow4 zero zero (px 3) (hex textShadowColor)
    , cursor pointer
    ]


resetLiStyle : Style
resetLiStyle =
    listStyle none


noteTitleStyle : Style
noteTitleStyle =
    Css.batch
        [ flexGrow (int 1)
        , marginLeft (px 20)
        ]


docs : Chapter x
docs =
    let
        props =
            { noteId = Note.intToNoteId 42
            , note = { title = "Milk" }
            , state = Pending
            , onTick = \_ -> logAction "Ticked"
            , onRemove = \_ -> logAction "Removed"
            , onEdit = \_ _ -> logAction "Edit clicked"
            }

        showcaseNote p =
            transparencyBackground
                { width = 650, height = 80 }
                (listedNoteView p)
    in
    chapter "Note"
        |> renderComponentList
            [ ( "Pending", showcaseNote props )
            , ( "Done", showcaseNote { props | state = Done, onTick = \_ -> logAction "Unticked" } )
            , ( "ToAdd", showcaseNote { props | state = ToAdd, onTick = \_ -> logAction "Added note" } )
            ]
