module TodoItems.Update (..) where

import TodoItems.Model exposing (..)
import TodoItem.Update as Item
import TodoItem.Model as ItemModel


type Action
  = Insert
  | Remove ID
  | Modify ID Item.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model
        | items = ( model.nextId, ItemModel.init ) :: model.items
        , nextId = model.nextId + 1
      }

    Remove id ->
      { model
        | items = List.filter (\( itemId, _ ) -> itemId /= id) model.items
      }

    Modify id itemAction ->
      let
        updateItem ( itemId, item ) =
          if itemId == id then
            ( itemId, Item.update itemAction item )
          else
            ( itemId, item )
      in
        { model
          | items = List.map updateItem model.items
        }
