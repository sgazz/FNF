import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let reward: Int
    let isUnlocked: Bool
    let dateUnlocked: Date?
    
    enum Category: String, Codable {
        case score = "Skor"
        case streak = "Streak"
        case powerUps = "Power-upovi"
        case time = "Vreme"
        case special = "Specijalna"
    }
    
    let category: Category
}

class AchievementManager: ObservableObject {
    static let shared = AchievementManager()
    
    @Published private(set) var achievements: [Achievement] = []
    private let defaults = UserDefaults.standard
    private let achievementsKey = "achievements"
    
    private init() {
        loadAchievements()
        if achievements.isEmpty {
            createDefaultAchievements()
        }
    }
    
    private func createDefaultAchievements() {
        achievements = [
            // Skor dostignuća
            Achievement(
                id: "score_1000",
                title: "Prvi koraci",
                description: "Ostvari skor od 1000 poena",
                icon: "star.fill",
                reward: 100,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            Achievement(
                id: "score_5000",
                title: "Napredni igrač",
                description: "Ostvari skor od 5000 poena",
                icon: "star.fill",
                reward: 500,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            Achievement(
                id: "score_10000",
                title: "Majstor",
                description: "Ostvari skor od 10000 poena",
                icon: "star.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            
            // Streak dostignuća
            Achievement(
                id: "streak_5",
                title: "Vatreni",
                description: "Ostvari streak od 5",
                icon: "flame.fill",
                reward: 200,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .streak
            ),
            Achievement(
                id: "streak_10",
                title: "Nezaustavljiv",
                description: "Ostvari streak od 10",
                icon: "flame.fill",
                reward: 500,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .streak
            ),
            
            // Power-up dostignuća
            Achievement(
                id: "powerups_10",
                title: "Power-up kolekcionar",
                description: "Iskoristi 10 power-upova",
                icon: "bolt.fill",
                reward: 300,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .powerUps
            ),
            Achievement(
                id: "powerups_50",
                title: "Power-up majstor",
                description: "Iskoristi 50 power-upova",
                icon: "bolt.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .powerUps
            ),
            
            // Vremenska dostignuća
            Achievement(
                id: "time_1h",
                title: "Početnik",
                description: "Igraj ukupno 1 sat",
                icon: "clock.fill",
                reward: 200,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .time
            ),
            Achievement(
                id: "time_5h",
                title: "Posvećeni",
                description: "Igraj ukupno 5 sati",
                icon: "clock.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .time
            ),
            
            // Specijalna dostignuća
            Achievement(
                id: "perfect_game",
                title: "Savršenstvo",
                description: "Ostvari savršenu partiju",
                icon: "crown.fill",
                reward: 2000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .special
            ),
            Achievement(
                id: "all_achievements",
                title: "Legenda",
                description: "Otključaj sva dostignuća",
                icon: "trophy.fill",
                reward: 5000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .special
            )
        ]
        saveAchievements()
    }
    
    func updateProgress(
        totalScore: Int,
        highScore: Int,
        gamesPlayed: Int,
        playTime: Int,
        maxCombo: Int,
        maxLevel: Int,
        powerUpsUsed: Int,
        perfectGames: Int
    ) {
        var hasNewAchievement = false
        
        // Proveri skor dostignuća
        if totalScore >= 1000 {
            hasNewAchievement = unlockAchievement("score_1000")
        }
        if totalScore >= 5000 {
            hasNewAchievement = unlockAchievement("score_5000")
        }
        if totalScore >= 10000 {
            hasNewAchievement = unlockAchievement("score_10000")
        }
        
        // Proveri streak dostignuća
        if maxCombo >= 5 {
            hasNewAchievement = unlockAchievement("streak_5")
        }
        if maxCombo >= 10 {
            hasNewAchievement = unlockAchievement("streak_10")
        }
        
        // Proveri power-up dostignuća
        if powerUpsUsed >= 10 {
            hasNewAchievement = unlockAchievement("powerups_10")
        }
        if powerUpsUsed >= 50 {
            hasNewAchievement = unlockAchievement("powerups_50")
        }
        
        // Proveri vremenska dostignuća
        if playTime >= 60 {
            hasNewAchievement = unlockAchievement("time_1h")
        }
        if playTime >= 300 {
            hasNewAchievement = unlockAchievement("time_5h")
        }
        
        // Proveri specijalna dostignuća
        if perfectGames > 0 {
            hasNewAchievement = unlockAchievement("perfect_game")
        }
        
        // Proveri da li su sva dostignuća otključana
        if achievements.allSatisfy({ $0.isUnlocked }) {
            hasNewAchievement = unlockAchievement("all_achievements")
        }
        
        if hasNewAchievement {
            saveAchievements()
        }
    }
    
    private func unlockAchievement(_ id: String) -> Bool {
        guard let index = achievements.firstIndex(where: { $0.id == id }),
              !achievements[index].isUnlocked else {
            return false
        }
        
        achievements[index] = Achievement(
            id: achievements[index].id,
            title: achievements[index].title,
            description: achievements[index].description,
            icon: achievements[index].icon,
            reward: achievements[index].reward,
            isUnlocked: true,
            dateUnlocked: Date(),
            category: achievements[index].category
        )
        
        // Prikaži efekat za dostignuće
        EffectManager.shared.showAchievement(achievements[index])
        
        return true
    }
    
    private func saveAchievements() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            defaults.set(encoded, forKey: achievementsKey)
        }
    }
    
    private func loadAchievements() {
        if let data = defaults.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
    }
    
    func getUnlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.isUnlocked }
    }
    
    func getLockedAchievements() -> [Achievement] {
        return achievements.filter { !$0.isUnlocked }
    }
    
    func getAchievementsByCategory(_ category: Achievement.Category) -> [Achievement] {
        return achievements.filter { $0.category == category }
    }
    
    func resetAchievements() {
        achievements = achievements.map { achievement in
            Achievement(
                id: achievement.id,
                title: achievement.title,
                description: achievement.description,
                icon: achievement.icon,
                reward: achievement.reward,
                isUnlocked: false,
                dateUnlocked: nil,
                category: achievement.category
            )
        }
        saveAchievements()
    }
} 