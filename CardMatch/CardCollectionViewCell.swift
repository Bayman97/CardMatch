//
//  CardCollectionViewCell.swift
//  CardMatch
//
//  Created by Michael Zeng on 2020-11-20.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!

    var card:Card?

    func configureCell(card:Card) {

        // keep track of the card this cell represents
        self.card = card

        // Set from image view of the front of the card
        frontImageView.image = UIImage(named: card.imageName)

        // reset the state of the cell by checking the flipped status of the card and then showing the front of back imageView accordingly

        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1 
        }
        if card.isFlipped == true {

            // show front imageView
            flipUP(speed: 0)

        }
        else {

            // show back imageView
            flipDown(speed: 0, delay: 0)
        }
    }

    // if parameter is not specified, than the default value is 0.3 
    func flipUP(speed:TimeInterval = 0.3) {

        // flip up animation 
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)

        // set card status
        card?.isFlipped = true

    }

    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {

        // delays the flip down animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            // flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)

        }

        // set card status
        card?.isFlipped = false 

    }

    // make image views invisible
    func remove() {

        // removes opaque quality of the card
        backImageView.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations:  {

            self.frontImageView.alpha = 0

        }, completion: nil)

    }

}
