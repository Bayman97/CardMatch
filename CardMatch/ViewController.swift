//
//  ViewController.swift
//  CardMatch
//
//  Created by Michael Zeng on 2020-11-20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // reference to the collection view 
    @IBOutlet weak var collectionView: UICollectionView!

    let model = CardModel()
    var cardsArray = [Card]()

    // if no card is selected, then value = NIL
    var firstFlippedCardIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        cardsArray = model.getCards()

        // set view controller as datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }


    // MARK: - Collection View Delegate Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // return the number of cards
        return cardsArray.count
    }

    // index path parameter tells us which cell we are at: .section = section number and .row = cell number
    // called when cell is created
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // this method is used for each cell
        // asks what we what do display in the cell and how its configured

        // get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell

        // return the cell
        return cell
    }

    // called right before cell is displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        // configure cell state based on properties of the card it represents
        let cardCell = cell as? CardCollectionViewCell

        // get the card from the card array using row
        // configure the cell
        cardCell?.configureCell(card: cardsArray[indexPath.row])
    }
    // index path indicates which cell the user selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell

        if cell?.card?.isFlipped ==  false  && cell?.card?.isMatched == false {

            // flip the card up
            cell?.flipUP()

            // check if this is first or second card flipped
            if firstFlippedCardIndex == nil {

                // this is the first card flipped
                firstFlippedCardIndex = indexPath
            }
            else{

                // this is the second card flip

                // compare the cards
                checkForMatch(indexPath)
            }
        }
    }

    // MARK: - Game Logic Methods

    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {

        // get both card objects for the 2 indicies and check for match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]

        // get 2 collection view cells that represent cards one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

        // compare the two cards
        if cardOne.imageName == cardTwo.imageName {

            // match
            // set status and remove cards
            cardOne.isMatched = true
            cardTwo.isMatched = true

            // optional chaining ("?") if they are nil, then no methods are called
            cardOneCell?.remove()
            cardTwoCell?.remove()
        }
        else {

            // no match

            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip them down
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()

        }

        // reset firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
}

