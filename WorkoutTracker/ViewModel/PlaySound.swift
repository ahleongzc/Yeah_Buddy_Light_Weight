//
//  PlaySound.swift
//  WorkoutTracker
//
//  Created by Leong Zhe Cheng on 19/05/2022.
//

import Foundation
import AVFoundation

var player: AVAudioPlayer!

func playSound() {
    
    let url = Bundle.main.url(forResource: "yblw", withExtension: "mp3")
    
    guard url != nil else { return }
    
    do {
        player = try AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        player.setVolume(0.8, fadeDuration: 1.0)
        player.currentTime = 0
        player.play()
    } catch {
        print("error")
    }
}
