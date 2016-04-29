module TodoItem.Model (Model, init) where


type alias Model =
  { content : String
  , done : Bool
  }


init : Model
init =
  { content = ""
  , done = False
  }
