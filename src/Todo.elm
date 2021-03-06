module Todo exposing (..)

import Html exposing (..)
import Html.Keyed as Keyed
import Html.Attributes exposing (style, type', value, draggable)
import Html.Events exposing (on, onWithOptions, onClick, targetValue)
import Html.App
import Json.Decode as Json
import List.Extra as List


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { todos : Todos
    , isDragging : Maybe String
    , mouseOver : Bool
    }


type alias Todos =
    List Todo


type alias Todo =
    { id : String
    , action : String
    , done : Bool
    , tags : List String
    , context : List String
    , priority : Int
    , due : Maybe Float
    , delegated : Maybe String
    }


defaultTodo : Todo
defaultTodo =
    { id = ""
    , action = ""
    , done = False
    , tags = []
    , context = []
    , priority = 0
    , due = Nothing
    , delegated = Nothing
    }


initialTodos : Todos
initialTodos =
    [ { defaultTodo | id = "1", action = "Buy train ticket" }
    , { defaultTodo | id = "2", action = "Buy sandwiches" }
    , { defaultTodo | id = "3", action = "Lookup directions" }
    ]


init : ( Model, Cmd Msg )
init =
    { todos = initialTodos
    , isDragging = Nothing
    , mouseOver = False
    }
        ! []



-- UPDATE


type Msg
    = Toggle String
    | StartDragging String
    | StopDragging
    | DragOver String
    | MouseOver Bool


insertAt : Int -> a -> List a -> List a
insertAt index elem list =
    if index == 0 then
        elem :: list
    else
        case list of
            [] ->
                []

            head :: tail ->
                head :: insertAt (index - 1) elem tail


moveTo : Int -> Int -> List a -> List a
moveTo startIndex destIndex list =
    let
        maybeElem =
            list
                |> List.getAt startIndex

        setElemToNewPosition xs =
            maybeElem
                |> Maybe.map (\x -> insertAt destIndex x xs)
                |> Maybe.withDefault xs
    in
        if destIndex >= List.length list then
            list
        else
            list
                |> List.removeAt startIndex
                |> setElemToNewPosition


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Current Message" msg of
        Toggle id ->
            let
                newTodos =
                    toggleDone id model.todos
            in
                { model | todos = newTodos } ! []

        StartDragging id ->
            let
                isDragging =
                    if model.mouseOver then
                        Nothing
                    else
                        Just id
            in
                { model | isDragging = isDragging } ! []

        StopDragging ->
            { model | isDragging = Nothing } ! []

        MouseOver mouseOver ->
            { model | mouseOver = mouseOver } ! []

        DragOver overId ->
            let
                draggedId =
                    case model.isDragging of
                        Just id ->
                            id

                        Nothing ->
                            Debug.crash "cannot be dragover without item being dragged!"

                getIndex fn =
                    model.todos
                        |> List.findIndex fn
                        |> Maybe.withDefault 0

                overIndex =
                    getIndex (\a -> a.id == overId)

                draggedIndex =
                    getIndex (\a -> a.id == draggedId)

                todos =
                    model.todos
                        |> moveTo draggedIndex overIndex
            in
                { model | todos = todos } ! []


findNextAction : Todos -> String
findNextAction todos =
    todos
        |> List.find nextActionCandidate
        |> Maybe.withDefault defaultTodo
        |> .id


nextActionCandidate : Todo -> Bool
nextActionCandidate { done, delegated } =
    not done && delegated == Nothing


toggleDone : String -> Todos -> Todos
toggleDone id todos =
    List.map
        (\todo ->
            if todo.id == id then
                { todo | done = not todo.done }
            else
                todo
        )
        todos



-- VIEW


view : Model -> Html Msg
view { todos, mouseOver } =
    todosView todos mouseOver


todosView : Todos -> Bool -> Html Msg
todosView todos mouseOver =
    Keyed.ul [] <| List.map (todoView (findNextAction todos) mouseOver) todos


todoView : String -> Bool -> Todo -> ( String, Html Msg )
todoView nextActionId mouseOver { id, action, done } =
    ( id
    , li
        [ draggable "true"
        , onWithOptions "dragstart" { stopPropagation = mouseOver, preventDefault = mouseOver } <| Json.succeed (StartDragging id)
        , on "dragend" <| Json.succeed StopDragging
        , on "dragenter" <| Json.succeed (DragOver id)
        ]
        [ input
            [ type' "checkbox"
            , onClick <| Toggle id
            , value <| toString done
            ]
            []
        , input
            [ type' "text"
            , value action
            , on "mouseenter" <| Json.succeed <| MouseOver True
            , on "mouseleave" <| Json.succeed <| MouseOver False
            ]
            []
        , nextActionView <| nextActionId == id
        ]
    )


nextActionView : Bool -> Html Msg
nextActionView active =
    if active then
        span
            [ style
                [ "color" => "red"
                ]
            ]
            [ text "Next Action!" ]
    else
        text ""


(=>) : String -> String -> ( String, String )
(=>) =
    (,)
