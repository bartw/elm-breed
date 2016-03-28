module SimpleApp where

import Html exposing (..)
import Html.Events exposing (onClick)

-- MODEL

type alias Model = String

-- UPDATE

type Action = 
    NoOp
    | Change

update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model
            
        Change ->
            "Bart"

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model = 
    div []
    [ button [ onClick address Change ] [ text "change" ]
    , div [] [ text (model) ]
    ]
    
-- INPUTS

main : Signal Html
main =
    Signal.map (view actions.address) model
  
model : Signal Model
model =
    Signal.foldp update initialModel actions.signal 
  
initialModel : Model
initialModel =
    "Nancy"  
    
actions : Signal.Mailbox Action 

actions =
    Signal.mailbox NoOp