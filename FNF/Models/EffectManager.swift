import SwiftUI

class EffectManager: ObservableObject {
    static let shared = EffectManager()
    
    @Published var showingCombo = false
    @Published var showingLevelUp = false
    @Published var showingScore = false
    @Published var showingAchievement = false
    
    @Published var comboMultiplier = 1
    @Published var level = 1
    @Published var score = 0
    @Published var achievement: Achievement?
    
    @Published var opacity: Double = 0
    
    private var effectQueue: [EffectType] = []
    private var isProcessingQueue = false
    
    private init() {}
    
    enum EffectType {
        case combo(Int)
        case levelUp(Int)
        case score(Int)
        case achievement(Achievement)
    }
    
    func showCombo(_ multiplier: Int) {
        addToQueue(.combo(multiplier))
    }
    
    func showLevelUp(_ level: Int) {
        addToQueue(.levelUp(level))
    }
    
    func showScore(_ score: Int) {
        addToQueue(.score(score))
    }
    
    func showAchievement(_ achievement: Achievement) {
        addToQueue(.achievement(achievement))
    }
    
    private func addToQueue(_ effect: EffectType) {
        effectQueue.append(effect)
        if !isProcessingQueue {
            processNextEffect()
        }
    }
    
    private func processNextEffect() {
        guard !effectQueue.isEmpty else {
            isProcessingQueue = false
            return
        }
        
        isProcessingQueue = true
        let effect = effectQueue.removeFirst()
        
        // Resetuj sve efekte
        showingCombo = false
        showingLevelUp = false
        showingScore = false
        showingAchievement = false
        
        // Prikaži trenutni efekat
        switch effect {
        case .combo(let multiplier):
            comboMultiplier = multiplier
            showingCombo = true
        case .levelUp(let level):
            self.level = level
            showingLevelUp = true
        case .score(let score):
            self.score = score
            showingScore = true
        case .achievement(let achievement):
            self.achievement = achievement
            showingAchievement = true
        }
        
        // Fade in animacija
        withAnimation(.easeIn(duration: 0.15)) {
            opacity = 1
        }
        
        // Sačekaj 0.3 sekunde za prikaz efekta
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            // Fade out animacija
            withAnimation(.easeOut(duration: 0.15)) {
                self?.opacity = 0
            }
            
            // Resetuj efekat nakon fade out-a
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                self?.showingCombo = false
                self?.showingLevelUp = false
                self?.showingScore = false
                self?.showingAchievement = false
                
                // Sačekaj 0.1 sekunde pre sledećeg efekta
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    self?.processNextEffect()
                }
            }
        }
    }
} 