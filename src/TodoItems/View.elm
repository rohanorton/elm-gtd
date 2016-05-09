module TodoItems.View (..) where

import TodoItem.View
import TodoItem.Model
import TodoItem.Update
import TodoItems.Model exposing (..)
import TodoItems.Update exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Signal.Address Action -> Model -> Html
view address model =
  let
    insert =
      button [ onClick address Insert ] [ text "Add" ]
  in
    div
      []
      [ div
          [ class "container" ]
          (insert :: List.map (viewItem address) model.items)
      ]


viewItem : Signal.Address Action -> ( ID, TodoItem.Model.Model ) -> Html
viewItem address ( id, model ) =
  let
    context =
      TodoItem.View.Context
        (Signal.forwardTo address (Modify id))
        (Signal.forwardTo address (always (Remove id)))
  in
    TodoItem.View.view context model
