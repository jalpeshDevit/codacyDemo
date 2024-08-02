//
//  Heptic.swift
//  DevPractical
//
//  Created by Jalpesh Patel on 05/01/24.
//

import Foundation

import CoreHaptics

import AVFoundation

class SoundManager {
    
    //MARK: - Variable
    
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() { }

    //MARK: - Function
    private func loadSound(named fileName: SoundName) {
        guard let path = Bundle.main.path(forResource: fileName.rawValue, ofType: "mp3") else {
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound file \(fileName): \(error.localizedDescription)")
        }
    }

    func playSound(named soundName: SoundName) {
            loadSound(named: soundName)
            audioPlayer?.play()
        }
}
