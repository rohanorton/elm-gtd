module Stylesheets (..) where

import Css exposing (Stylesheet)
import Css.File exposing (CssFileStructure)
import TodoItem
import TodoItems


compileStylesheets : List Stylesheet -> { css : String, warnings : List String }
compileStylesheets =
  let
    concatStylesheets memo new =
      { css = memo.css ++ new.css
      , warnings = memo.warnings ++ new.warnings
      }
  in
    List.foldl concatStylesheets { css = "", warnings = [] } << List.map Css.compile


port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "styles.css"
      , compileStylesheets
          [ TodoItem.css
          , TodoItems.css
          ]
      )
    ]
