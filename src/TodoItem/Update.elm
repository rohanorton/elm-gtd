module TodoItem.Update (..) where

import TodoItem.Model exposing (..)


type Action
  = Update String
  | Check


update : Action -> Model -> Model
update action model =
  case action of
    Update content ->
      { model | content = content }

    Check ->
      { model | done = (not model.done) }
