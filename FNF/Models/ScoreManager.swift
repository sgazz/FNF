import Foundation

class ScoreManager {
    static let shared = ScoreManager()
    
    private let defaults = UserDefaults.standard
    private let highScoreKey = "highScore"
    private let achievementsKey = "achievements"
    
    private init() {}
    
    // MARK: - High Scores
    
    var highScore: Int {
        get { defaults.integer(forKey: highScoreKey) }
        set { defaults.set(newValue, forKey: highScoreKey) }
    }
    
    func updateHighScore(_ score: Int) {
        if score > highScore {
            highScore = score
        }
    }
    
    // MARK: - Achievements
    
    struct Achievement: Codable, Identifiable {
        let id: String
        let title: String
        let description: String
        let isUnlocked: Bool
        let dateUnlocked: Date?
    }
    
    var achievements: [Achievement] {
        get {
            guard let data = defaults.data(forKey: achievementsKey),
                  let achievements = try? JSONDecoder().decode([Achievement].self, from: data) else {
                return defaultAchievements
            }
            return achievements
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: achievementsKey)
            }
        }
    }
    
    private var defaultAchievements: [Achievement] {
        [
            Achievement(id: "first_game", title: "Prva igra", description: "Završi svoju prvu igru", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "score_1000", title: "Početnik", description: "Ostvari 1000 poena", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "score_5000", title: "Napredni", description: "Ostvari 5000 poena", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "score_10000", title: "Majstor", description: "Ostvari 10000 poena", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "combo_3", title: "Kombo majstor", description: "Ostvari 3x kombo", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "combo_5", title: "Kombo legenda", description: "Ostvari 5x kombo", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "level_5", title: "Napredak", description: "Dostigni nivo 5", isUnlocked: false, dateUnlocked: nil),
            Achievement(id: "level_10", title: "Ekspert", description: "Dostigni nivo 10", isUnlocked: false, dateUnlocked: nil)
        ]
    }
    
    func checkAchievements(score: Int, level: Int, maxCombo: Int) {
        var updatedAchievements = achievements
        
        // Proveri dostignuća za skor
        if score >= 1000 {
            unlockAchievement(id: "score_1000", in: &updatedAchievements)
        }
        if score >= 5000 {
            unlockAchievement(id: "score_5000", in: &updatedAchievements)
        }
        if score >= 10000 {
            unlockAchievement(id: "score_10000", in: &updatedAchievements)
        }
        
        // Proveri dostignuća za kombo
        if maxCombo >= 3 {
            unlockAchievement(id: "combo_3", in: &updatedAchievements)
        }
        if maxCombo >= 5 {
            unlockAchievement(id: "combo_5", in: &updatedAchievements)
        }
        
        // Proveri dostignuća za nivo
        if level >= 5 {
            unlockAchievement(id: "level_5", in: &updatedAchievements)
        }
        if level >= 10 {
            unlockAchievement(id: "level_10", in: &updatedAchievements)
        }
        
        achievements = updatedAchievements
    }
    
    private func unlockAchievement(id: String, in achievements: inout [Achievement]) {
        if let index = achievements.firstIndex(where: { $0.id == id && !$0.isUnlocked }) {
            achievements[index] = Achievement(
                id: achievements[index].id,
                title: achievements[index].title,
                description: achievements[index].description,
                isUnlocked: true,
                dateUnlocked: Date()
            )
        }
    }
    
    // MARK: - Game Modes
    
    enum GameMode: String {
        case classic = "classic"
        case timeAttack = "timeAttack"
        case zen = "zen"
        
        var settings: (targetNumber: Int, timeLimit: Int?) {
            switch self {
            case .classic:
                return (10, nil)
            case .timeAttack:
                return (15, 180) // 3 minuta
            case .zen:
                return (8, nil)
            }
        }
    }
    
    func getModeSettings(_ mode: GameMode) -> (targetNumber: Int, timeLimit: Int?) {
        return mode.settings
    }
} 