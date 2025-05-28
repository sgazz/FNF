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
        case score = "Score"
        case streak = "Streak"
        case powerUps = "Power-ups"
        case time = "Time"
        case special = "Special"
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
            // Score achievements
            Achievement(
                id: "score_1000",
                title: "First Steps",
                description: "Achieve a score of 1000 points",
                icon: "star.fill",
                reward: 100,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            Achievement(
                id: "score_5000",
                title: "Advanced Player",
                description: "Achieve a score of 5000 points",
                icon: "star.fill",
                reward: 500,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            Achievement(
                id: "score_10000",
                title: "Master",
                description: "Achieve a score of 10000 points",
                icon: "star.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .score
            ),
            
            // Streak achievements
            Achievement(
                id: "streak_5",
                title: "On Fire",
                description: "Achieve a streak of 5",
                icon: "flame.fill",
                reward: 200,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .streak
            ),
            Achievement(
                id: "streak_10",
                title: "Unstoppable",
                description: "Achieve a streak of 10",
                icon: "flame.fill",
                reward: 500,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .streak
            ),
            
            // Power-up achievements
            Achievement(
                id: "powerups_10",
                title: "Power-up Collector",
                description: "Use 10 power-ups",
                icon: "bolt.fill",
                reward: 300,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .powerUps
            ),
            Achievement(
                id: "powerups_50",
                title: "Power-up Master",
                description: "Use 50 power-ups",
                icon: "bolt.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .powerUps
            ),
            
            // Time achievements
            Achievement(
                id: "time_1h",
                title: "Beginner",
                description: "Play for a total of 1 hour",
                icon: "clock.fill",
                reward: 200,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .time
            ),
            Achievement(
                id: "time_5h",
                title: "Dedicated",
                description: "Play for a total of 5 hours",
                icon: "clock.fill",
                reward: 1000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .time
            ),
            
            // Special achievements
            Achievement(
                id: "perfect_game",
                title: "Perfection",
                description: "Achieve a perfect game",
                icon: "crown.fill",
                reward: 2000,
                isUnlocked: false,
                dateUnlocked: nil,
                category: .special
            ),
            Achievement(
                id: "all_achievements",
                title: "Legend",
                description: "Unlock all achievements",
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