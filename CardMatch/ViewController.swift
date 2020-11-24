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
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()

    var timer:Timer?
    var milliseconds:Int = 20 * 1000

    // if no card is selected, then value = NIL
    var firstFlippedCardIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        cardsArray = model.getCards()

        // set view controller as datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self

        // initialize timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }

    // MARK: - Timer Methods

    // objective c internals -> allows swift to utilize objective c
    @objc func timerFired() {

        // decrement the counter
        milliseconds = milliseconds - 1

        // update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)

        // stop timer if it reaches 0
        if milliseconds == 0 {

            timerLabel.textColor = UIColor.red
            timer?.invalidate()

            // check if the user has cleared all the pairs
            checkForGameEnd()
        }



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

            // was that the last pair?
            checkForGameEnd()
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

    func checkForGameEnd() {

        // check if any cards are unmatched
        var hasWon = true

        for card in cardsArray {

            if card.isMatched == false {

                hasWon = false
                break
            }
        }

        if hasWon == true {

            // user has won, show an alert
            showAlert(title: "Congratulations!", message: "You've won the game!")

        }
        else {

            // user hasn't won, check if there is any time left
            if milliseconds <= 0 {

                showAlert(title: "Time's up", message: "Sorry, better luck next time")
            }

        }
    }

    func showAlert(title: String, message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // add a button to dismiss the alert
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

