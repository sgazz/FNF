import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    private let highScoresKey = "highScores"
    private let audioSettingsKey = "audioSettings"
    private let gameModeKey = "selectedGameMode"
    private let lastPlayedDateKey = "lastPlayedDate"
    private let totalPlayTimeKey = "totalPlayTime"
    private let gamesPlayedKey = "gamesPlayed"
    private let totalScoreKey = "totalScore"
    
    private init() {}
    
    // MARK: - High Scores
    
    func getHighScores() -> [Int] {
        return defaults.array(forKey: highScoresKey) as? [Int] ?? []
    }
    
    func saveHighScore(_ score: Int) {
        var highScores = getHighScores()
        highScores.append(score)
        highScores.sort(by: >)
        highScores = Array(highScores.prefix(10)) // Keep only top 10
        defaults.set(highScores, forKey: highScoresKey)
    }
    
    func getHighScore() -> Int {
        return getHighScores().first ?? 0
    }
    
    // MARK: - Audio Settings
    
    func isMuted() -> Bool {
        return defaults.bool(forKey: audioSettingsKey)
    }
    
    func setMuted(_ muted: Bool) {
        defaults.set(muted, forKey: audioSettingsKey)
    }
    
    // MARK: - Game Mode
    
    func getSelectedMode() -> ScoreManager.GameMode {
        if let rawValue = defaults.string(forKey: gameModeKey),
           let mode = ScoreManager.GameMode(rawValue: rawValue) {
            return mode
        }
        return .classic
    }
    
    func setSelectedMode(_ mode: ScoreManager.GameMode) {
        defaults.set(mode.rawValue, forKey: gameModeKey)
    }
    
    // MARK: - Game Statistics
    
    func updateLastPlayedDate() {
        defaults.set(Date(), forKey: lastPlayedDateKey)
    }
    
    func getLastPlayedDate() -> Date? {
        return defaults.object(forKey: lastPlayedDateKey) as? Date
    }
    
    func updateTotalPlayTime(_ minutes: Int) {
        let currentTime = defaults.integer(forKey: totalPlayTimeKey)
        defaults.set(currentTime + minutes, forKey: totalPlayTimeKey)
    }
    
    func getTotalPlayTime() -> Int {
        return defaults.integer(forKey: totalPlayTimeKey)
    }
    
    func updateGamesPlayed() {
        let currentGames = defaults.integer(forKey: gamesPlayedKey)
        defaults.set(currentGames + 1, forKey: gamesPlayedKey)
    }
    
    func getGamesPlayed() -> Int {
        return defaults.integer(forKey: gamesPlayedKey)
    }
    
    func updateTotalScore(_ score: Int) {
        let currentScore = defaults.integer(forKey: totalScoreKey)
        defaults.set(currentScore + score, forKey: totalScoreKey)
    }
    
    func getTotalScore() -> Int {
        return defaults.integer(forKey: totalScoreKey)
    }
    
    // MARK: - Reset Data
    
    func resetAllData() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
} 