module Ui.Book exposing (main)

import ElmBook exposing (withChapters, withThemeOptions)
import ElmBook.ElmCSS exposing (Book, Chapter, book)
import ElmBook.ThemeOptions
import Ui.Button


main =
    book "Components"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.preferDarkMode
            ]
        |> withChapters
            [ Ui.Button.docs
            ]
