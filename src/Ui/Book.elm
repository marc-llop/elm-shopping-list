module Ui.Book exposing (main)

import DesignSystem.Colors
import DesignSystem.Icons
import DesignSystem.StyledIcons
import ElmBook exposing (withChapterGroups, withThemeOptions)
import ElmBook.ElmCSS exposing (Book, Chapter, book)
import ElmBook.ThemeOptions
import Ui.Button
import Ui.FloatingActionButton
import Ui.Glassmorphism
import Ui.ListedNote


main =
    book "Components"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.preferDarkMode
            ]
        |> withChapterGroups
            [ ( "Design Tokens"
              , [ DesignSystem.Colors.docs
                , DesignSystem.Icons.docs
                , DesignSystem.StyledIcons.docs
                ]
              )
            , ( "Components"
              , [ Ui.Button.docs
                , Ui.ListedNote.docs
                , Ui.Glassmorphism.docs
                , Ui.FloatingActionButton.docs
                ]
              )
            ]
