module Breed where

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model = 
    { people : List Person
    , firstNameField : String
    , lastNameField : String
    , uid : Int
    }
    
type alias Person =
    { firstName : String
    , lastName : String
    , id : Int
    }
    
emptyModel : Model
emptyModel =
    { people = []
    , firstNameField = ""
    , lastNameField = ""
    , uid = 0
    }
    
newPerson : String -> String -> Int -> Person
newPerson firstName lastName id =
    { firstName = firstName
    , lastName = lastName
    , id = id
    }    

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
initialModel = emptyModel  

actions : Signal.Mailbox Action 

actions =
    Signal.mailbox NoOp