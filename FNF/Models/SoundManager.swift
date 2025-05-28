import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var sounds: [String: AVAudioPlayer] = [:]
    private var isMuted = false
    
    private init() {
        preloadSounds()
    }
    
    private func preloadSounds() {
        let soundNames = [
            "move": "move",
            "rotate": "rotate",
            "drop": "drop",
            "clear": "clear",
            "combo": "combo",
            "powerup": "powerup",
            "gameover": "gameover"
        ]
        
        for (key, name) in soundNames {
            if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    sounds[key] = player
                } catch {
                    print("Error loading sound \(name): \(error)")
                }
            }
        }
    }
    
    func playSound(_ name: String) {
        guard !isMuted else { return }
        
        if let player = sounds[name] {
            player.currentTime = 0
            player.play()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
    
    func setMute(_ muted: Bool) {
        isMuted = muted
    }
} 