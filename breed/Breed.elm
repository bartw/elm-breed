module Breed where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2, lazy3)
import Signal exposing (Signal, Address)
import String

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
    | UpdateFirstNameField String
    | UpdateLastNameField String
    | AddPerson
    
update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        
        UpdateFirstNameField firstName ->
            { model | firstNameField = firstName }
            
        UpdateLastNameField lastName ->
            { model | lastNameField = lastName }
        
        AddPerson ->
            { model |
                uid = model.uid + 1,
                firstNameField = "",
                lastNameField = "",
                people =
                    if String.isEmpty model.firstNameField || String.isEmpty model.lastNameField
                    then model.people
                    else model.people ++ [ newPerson model.firstNameField model.lastNameField model.uid ]
            }

-- VIEW

view : Address Action -> Model -> Html
view address model =
    div
        [ class "breed-wrapper" ]
        [ div 
            [ id "breedapp" ] 
            [ lazy3 personEntry address model.firstNameField model.lastNameField
            , lazy2 personList address model.people
            ]
        ]

personEntry : Address Action -> String -> String -> Html
personEntry address firstName lastName = 
    header
        [ id "header" ]
        [ h1 [] [ text "people" ]
        , input 
            [ id "newFirstName"
            , placeholder "Firstname"
            , autofocus True
            , value firstName
            , name "newFirstName"
            , on "input" targetValue (Signal.message address << UpdateFirstNameField)
            ]
            []
        , input 
            [ id "newLastName"
            , placeholder "Lastname"
            , autofocus True
            , value lastName
            , name "newLastName"
            , on "input" targetValue (Signal.message address << UpdateLastNameField)
            ]
            []
        , button
            [ id "addPerson"
            , onClick address AddPerson ]
            [ text "Add" ]
        ]
        
personList : Address Action -> List Person -> Html
personList address people =
    ul
        [ id "people-list" ]
        (List.map (personItem address) (people))  
        
personItem : Address Action -> Person -> Html
personItem address person =
    li
        [ class "person-item" ]
        [ text (person.firstName ++ " " ++ person.lastName) ]        

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