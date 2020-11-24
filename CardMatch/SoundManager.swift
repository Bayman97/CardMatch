//
//  SoundManager.swift
//  CardMatch
//
//  Created by Michael Zeng on 2020-11-24.
//

import Foundation
import AVFoundation


class SoundManager {

    var audioPlayer:AVAudioPlayer?

    // enum data type, it can be only one of the 4 values
    enum SoundEffect {
        case flip
        case match
        case noMatch
        case shuffle
    }

    // parameter is the sound the user wants to play
    func playSound(effect:SoundEffect) {

        var soundFileName = ""

        // switch statement
        switch effect {

            case .flip:
                soundFileName = "cardflip"

            case .match:
                soundFileName = "dingcorrect"

            case .noMatch:
                soundFileName = "dingwrong"

            case .shuffle:
                soundFileName = "shuffle"
        // default case for switch case is not needed in enum
        }

        // file path to audio files in your bundle
        // get the path to resource
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")

        // check that it is not nil
        // if equals nil, then we return, otherwise continue normally
        guard bundlePath != nil else {
            return
        }

        let url = URL(fileURLWithPath: bundlePath!)

        // error handling
        // this is used when something can throw an error
        do {
            // we attempt this line of code -> may throw an error
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // play the sound effect 
            audioPlayer?.play()
        }
        catch {
            // if there is an error
            print("Couldn't create an audio player")
            return
        }

    }

}
