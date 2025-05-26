import SwiftUI

class EffectManager: ObservableObject {
    static let shared = EffectManager()
    
    @Published var showingCombo = false
    @Published var comboMultiplier = 1
    @Published var showingLevelUp = false
    @Published var level = 1
    @Published var showingScore = false
    @Published var score = 0
    @Published var showingAchievement = false
    @Published var achievement: Achievement?
    
    private init() {}
    
    func showCombo(_ multiplier: Int) {
        comboMultiplier = multiplier
        showingCombo = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showingCombo = false
        }
    }
    
    func showLevelUp(_ newLevel: Int) {
        level = newLevel
        showingLevelUp = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showingLevelUp = false
        }
    }
    
    func showScore(_ points: Int) {
        score = points
        showingScore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showingScore = false
        }
    }
    
    func showAchievement(_ achievement: Achievement) {
        self.achievement = achievement
        showingAchievement = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showingAchievement = false
            self.achievement = nil
        }
    }
} 