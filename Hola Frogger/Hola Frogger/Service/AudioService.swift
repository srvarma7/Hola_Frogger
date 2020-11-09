//
//  AudioService.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 4/11/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

enum SoundType: String {
    case confetti   = "confetti"
    case frog       = "frog"
}

class AudioService {
    
//    var audioPlayer = AVAudioPlayer()
//    init(sound: SoundType) {
//        play(sound: sound)
//    }
    
//    func play(sound: SoundType) {
//        print(sound.rawValue)
//        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "test", ofType: "mp3")!)
//        do {
//             audioPlayer = try AVAudioPlayer(contentsOf: sound)
//             audioPlayer.play()
//        } catch {
//            debugPrint("Sound file not found")
//        }
//    }
    
    
    var player: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "test", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly */
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            print("Playing called", AVFileType.mp3.rawValue)
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
