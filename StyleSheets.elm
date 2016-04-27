module Stylesheets (..) where

import Css.File exposing (..)
import TodoItem


port files : CssFileStructure
port files =
  toFileStructure
    [ ( "styles.css", compile TodoItem.css ) ]
