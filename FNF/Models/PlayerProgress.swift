import Foundation

class PlayerProgress: ObservableObject {
    static let shared = PlayerProgress()
    
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var totalNumbersCleared: Int = 0
    @Published var powerUpsUsed: [PowerUpType: Int] = [:]
    @Published var highestCombo: Int = 0
    @Published var fastestLevelUp: TimeInterval?
    @Published var lastGameDate: Date?
    
    private let defaults = UserDefaults.standard
    private let streakKey = "currentStreak"
    private let bestStreakKey = "bestStreak"
    private let numbersClearedKey = "totalNumbersCleared"
    private let powerUpsKey = "powerUpsUsed"
    private let highestComboKey = "highestCombo"
    private let fastestLevelUpKey = "fastestLevelUp"
    private let lastGameKey = "lastGameDate"
    
    private init() {
        loadProgress()
    }
    
    func updateProgress(gameScore: Int, level: Int, maxCombo: Int, powerUps: [PowerUpType: Int], timePlayed: TimeInterval) {
        // Update streak
        if gameScore > 0 {
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
        } else {
            currentStreak = 0
        }
        
        // Update highest combo
        highestCombo = max(highestCombo, maxCombo)
        
        // Update power-up statistics
        for (type, count) in powerUps {
            powerUpsUsed[type, default: 0] += count
        }
        
        // Update fastest level reached
        if level > 1 {
            let timePerLevel = timePlayed / Double(level)
            if fastestLevelUp == nil || timePerLevel < fastestLevelUp! {
                fastestLevelUp = timePerLevel
            }
        }
        
        lastGameDate = Date()
        
        saveProgress()
    }
    
    func resetProgress() {
        currentStreak = 0
        bestStreak = 0
        totalNumbersCleared = 0
        powerUpsUsed = [:]
        highestCombo = 0
        fastestLevelUp = nil
        lastGameDate = nil
        
        saveProgress()
    }
    
    private func loadProgress() {
        currentStreak = defaults.integer(forKey: streakKey)
        bestStreak = defaults.integer(forKey: bestStreakKey)
        totalNumbersCleared = defaults.integer(forKey: numbersClearedKey)
        highestCombo = defaults.integer(forKey: highestComboKey)
        fastestLevelUp = defaults.double(forKey: fastestLevelUpKey)
        lastGameDate = defaults.object(forKey: lastGameKey) as? Date
        
        if let powerUpsData = defaults.data(forKey: powerUpsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: powerUpsData) {
            powerUpsUsed = Dictionary(uniqueKeysWithValues: decoded.compactMap { key, value in
                guard let type = PowerUpType(rawValue: Int(key) ?? 0) else { return nil }
                return (type, value)
            })
        }
    }
    
    private func saveProgress() {
        defaults.set(currentStreak, forKey: streakKey)
        defaults.set(bestStreak, forKey: bestStreakKey)
        defaults.set(totalNumbersCleared, forKey: numbersClearedKey)
        defaults.set(highestCombo, forKey: highestComboKey)
        defaults.set(fastestLevelUp, forKey: fastestLevelUpKey)
        defaults.set(lastGameDate, forKey: lastGameKey)
        
        let powerUpsData = Dictionary(uniqueKeysWithValues: powerUpsUsed.map { 
            (String($0.key.rawValue), $0.value)
        })
        if let encoded = try? JSONEncoder().encode(powerUpsData) {
            defaults.set(encoded, forKey: powerUpsKey)
        }
    }
    
    // MARK: - Helper Methods
    
    func getPowerUpUsageCount(for type: PowerUpType) -> Int {
        return powerUpsUsed[type] ?? 0
    }
    
    func getMostUsedPowerUp() -> PowerUpType? {
        return powerUpsUsed.max(by: { $0.value < $1.value })?.key
    }
    
    func getAverageScorePerGame() -> Int {
        let gamesPlayed = UserDefaultsManager.shared.getGamesPlayed()
        guard gamesPlayed > 0 else { return 0 }
        return UserDefaultsManager.shared.getTotalScore() / gamesPlayed
    }
    
    func getPlayTimeInHours() -> Double {
        return Double(UserDefaultsManager.shared.getTotalPlayTime()) / 60.0
    }
} 