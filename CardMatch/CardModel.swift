//
//  CardModel.swift
//  CardMatch
//
//  Created by Michael Zeng on 2020-11-20.
//

import Foundation


class CardModel {

    // returns an array of card objects
    func getCards() -> [Card] {

        // declare and empty array to store the cards
        // () indicate a new array object of that datatype is created
        var generatedCards = [Card]()

        // randmomly generate 8 pairs of cards
        while generatedCards.count < 16{

            // generate a random number
            let randomNumber = Int.random(in: 1...13)

            // check if this card pair has already been used
            var alreadyUsed = false

            // check against every card already generated 
            for cardNumber in generatedCards {
                if cardNumber.imageName == "card\(randomNumber)"{
                    alreadyUsed = true
                }
            }

            if alreadyUsed == false{

                // create 2 new card objects
                let card1 = Card()
                let card2 = Card()

                // set image names
                card1.imageName = "card\(randomNumber)"
                card2.imageName = "card\(randomNumber)"

                // add them to array
                // this appends card1 and card2 to the array
                generatedCards += [card1, card2]

                print(randomNumber)
            }

        }

        // randomize cards within the array
        generatedCards.shuffle()

        // return the array
        return generatedCards

    }



}

