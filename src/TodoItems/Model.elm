module TodoItems.Model (..) where

import TodoItem.Model as Item


type alias Model =
  { items : List ( ID, Item.Model )
  , nextId : ID
  }


type alias ID =
  Int


init : Model
init =
  { items = []
  , nextId = 0
  }
