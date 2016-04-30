module Main (..) where

import TodoItems.View exposing (view)
import TodoItems.Update exposing (update)
import TodoItems.Model exposing (init)
import StartApp.Simple exposing (start)


main =
  start
    { model = init
    , update = update
    , view = view
    }
