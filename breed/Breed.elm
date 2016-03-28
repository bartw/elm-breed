module Breed where

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model = 
    {}

-- UPDATE

type Action
    = NoOp
    
update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model   

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    div
      [ class "breed-wrapper" ]
      [ div [ id "breedapp" ] [ text ("breed") ] ]


-- INPUTS

main : Signal Html
main =
    Signal.map (view actions.address) model

model : Signal Model
model =
    Signal.foldp update initialModel actions.signal 

initialModel : Model
initialModel = {}  

actions : Signal.Mailbox Action 

actions =
    Signal.mailbox NoOp