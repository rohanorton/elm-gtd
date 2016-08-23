module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import Todo


all : Test
all =
    describe "moveTo"
        [ test "moving first element to end"
            <| \() ->
                [ 'a', 'b', 'c' ]
                    |> Todo.moveTo 0 2
                    |> Expect.equal [ 'b', 'c', 'a' ]
        , test "moving last element to beginning"
            <| \() ->
                [ 'a', 'b', 'c' ]
                    |> Todo.moveTo 2 0
                    |> Expect.equal [ 'c', 'a', 'b' ]
        , test "moving element out of bounds returns original list"
            <| \() ->
                [ 'a', 'b', 'c' ]
                    |> Todo.moveTo 0 3
                    |> Expect.equal [ 'a', 'b', 'c' ]
        , test "trying to move out of bounds element returns original list"
            <| \() ->
                [ 'a', 'b', 'c' ]
                    |> Todo.moveTo 3 0
                    |> Expect.equal [ 'a', 'b', 'c' ]
        , test "moving element to same position should return original list"
            <| \() ->
                [ 'a', 'b', 'c' ]
                    |> Todo.moveTo 0 0
                    |> Expect.equal [ 'a', 'b', 'c' ]
        ]
