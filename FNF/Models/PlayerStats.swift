import Foundation

struct PlayerStats: Codable {
    var totalScore: Int
    var highScore: Int
    var gamesPlayed: Int
    var totalPlayTime: TimeInterval
    var maxCombo: Int
    var maxLevel: Int
    var powerUpsUsed: [String: Int]
    var perfectGames: Int
    var mistakes: Int
    var lastPlayed: Date?
    
    static var `default`: PlayerStats {
        PlayerStats(
            totalScore: 0,
            highScore: 0,
            gamesPlayed: 0,
            totalPlayTime: 0,
            maxCombo: 0,
            maxLevel: 1,
            powerUpsUsed: [:],
            perfectGames: 0,
            mistakes: 0,
            lastPlayed: nil
        )
    }
}

class PlayerStatsManager: ObservableObject {
    static let shared = PlayerStatsManager()
    
    @Published private(set) var stats: PlayerStats
    private let defaults = UserDefaults.standard
    private let statsKey = "player_stats"
    
    private init() {
        if let data = defaults.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(PlayerStats.self, from: data) {
            stats = decoded
        } else {
            stats = .default
        }
    }
    
    func updateStats(
        gameScore: Int,
        playTime: TimeInterval,
        powerUps: [PowerUpType: Int],
        isPerfect: Bool,
        mistakes: Int = 0
    ) {
        var newStats = stats
        
        // Ažuriraj osnovnu statistiku
        newStats.totalScore += gameScore
        newStats.highScore = max(newStats.highScore, gameScore)
        newStats.gamesPlayed += 1
        newStats.totalPlayTime += playTime
        newStats.lastPlayed = Date()
        
        // Ažuriraj power-up statistiku
        for (type, count) in powerUps {
            let key = type.symbol
            newStats.powerUpsUsed[key, default: 0] += count
        }
        
        // Ažuriraj ostalu statistiku
        if isPerfect {
            newStats.perfectGames += 1
        }
        newStats.mistakes += mistakes
        
        stats = newStats
        saveStats()
    }
    
    func updateGameStats(maxCombo: Int, maxLevel: Int) {
        var newStats = stats
        newStats.maxCombo = max(newStats.maxCombo, maxCombo)
        newStats.maxLevel = max(newStats.maxLevel, maxLevel)
        stats = newStats
        saveStats()
    }
    
    private func saveStats() {
        if let encoded = try? JSONEncoder().encode(stats) {
            defaults.set(encoded, forKey: statsKey)
        }
    }
    
    func resetStats() {
        stats = .default
        saveStats()
    }
    
    // Pomoćne metode za prikaz statistike
    func getAverageScore() -> Int {
        guard stats.gamesPlayed > 0 else { return 0 }
        return stats.totalScore / stats.gamesPlayed
    }
    
    func getAveragePlayTime() -> TimeInterval {
        guard stats.gamesPlayed > 0 else { return 0 }
        return stats.totalPlayTime / Double(stats.gamesPlayed)
    }
    
    func getMostUsedPowerUp() -> (symbol: String, count: Int)? {
        guard let max = stats.powerUpsUsed.max(by: { $0.value < $1.value }) else {
            return nil
        }
        return (symbol: max.key, count: max.value)
    }
    
    func getPerfectGamePercentage() -> Double {
        guard stats.gamesPlayed > 0 else { return 0 }
        return Double(stats.perfectGames) / Double(stats.gamesPlayed) * 100
    }
} 