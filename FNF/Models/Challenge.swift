import Foundation

struct Challenge: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let type: ChallengeType
    let target: Int
    let reward: Int
    var progress: Int
    var isCompleted: Bool
    var dateCompleted: Date?
    
    init(id: UUID = UUID(), title: String, description: String, type: ChallengeType, target: Int, reward: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.target = target
        self.reward = reward
        self.progress = 0
        self.isCompleted = false
        self.dateCompleted = nil
    }
}

enum ChallengeType: String, Codable {
    case score
    case combo
    case level
    case powerUps
    case streak
    case time
    
    var icon: String {
        switch self {
        case .score:
            return "star.fill"
        case .combo:
            return "bolt.fill"
        case .level:
            return "arrow.up.circle.fill"
        case .powerUps:
            return "wand.and.stars"
        case .streak:
            return "flame.fill"
        case .time:
            return "clock.fill"
        }
    }
}

class ChallengeManager: ObservableObject {
    static let shared = ChallengeManager()
    
    @Published var challenges: [Challenge] = []
    @Published var activeChallenges: [Challenge] = []
    @Published var dailyChallenges: [Challenge] = []
    @Published var dailyReward: Int = 0
    @Published var lastDailyReset: Date?
    
    private let defaults = UserDefaults.standard
    private let challengesKey = "savedChallenges"
    private let activeChallengesKey = "activeChallenges"
    private let dailyChallengesKey = "dailyChallenges"
    private let dailyRewardKey = "dailyReward"
    private let lastDailyResetKey = "lastDailyReset"
    
    private init() {
        loadChallenges()
        if activeChallenges.isEmpty {
            generateNewChallenges()
        }
        checkDailyReset()
    }
    
    private func checkDailyReset() {
        let calendar = Calendar.current
        if let lastReset = lastDailyReset {
            if !calendar.isDateInToday(lastReset) {
                resetDailyChallenges()
            }
        } else {
            resetDailyChallenges()
        }
    }
    
    private func resetDailyChallenges() {
        dailyChallenges = [
            generateDailyChallenge(type: .score),
            generateDailyChallenge(type: .combo),
            generateDailyChallenge(type: .level)
        ]
        dailyReward = Int.random(in: 100...500)
        lastDailyReset = Date()
        saveChallenges()
    }
    
    private func generateDailyChallenge(type: ChallengeType) -> Challenge {
        switch type {
        case .score:
            let target = Int.random(in: 1000...5000)
            return Challenge(
                title: "Daily Score",
                description: "Achieve \(target) points",
                type: type,
                target: target,
                reward: target / 10
            )
        case .combo:
            let target = Int.random(in: 3...7)
            return Challenge(
                title: "Daily Combo",
                description: "Achieve \(target)x combo",
                type: type,
                target: target,
                reward: target * 50
            )
        case .level:
            let target = Int.random(in: 2...5)
            return Challenge(
                title: "Daily Level",
                description: "Reach level \(target)",
                type: type,
                target: target,
                reward: target * 100
            )
        default:
            return generateDailyChallenge(type: .score)
        }
    }
    
    func claimDailyReward() {
        if dailyReward > 0 {
            UserDefaultsManager.shared.updateTotalScore(dailyReward)
            dailyReward = 0
            saveChallenges()
        }
    }
    
    func updateProgress(gameScore: Int, maxCombo: Int, level: Int, powerUpsUsed: Int, streak: Int, timePlayed: TimeInterval) {
        var updatedChallenges = activeChallenges
        var updatedDailyChallenges = dailyChallenges
        
        // Ažuriraj aktivne izazove
        for (index, challenge) in updatedChallenges.enumerated() {
            if challenge.isCompleted { continue }
            
            var newProgress = challenge.progress
            var isCompleted = false
            
            switch challenge.type {
            case .score:
                newProgress = gameScore
                isCompleted = gameScore >= challenge.target
            case .combo:
                newProgress = maxCombo
                isCompleted = maxCombo >= challenge.target
            case .level:
                newProgress = level
                isCompleted = level >= challenge.target
            case .powerUps:
                newProgress = powerUpsUsed
                isCompleted = powerUpsUsed >= challenge.target
            case .streak:
                newProgress = streak
                isCompleted = streak >= challenge.target
            case .time:
                newProgress = Int(timePlayed / 60)
                isCompleted = newProgress >= challenge.target
            }
            
            if newProgress != challenge.progress || isCompleted {
                var updatedChallenge = challenge
                updatedChallenge.progress = newProgress
                updatedChallenge.isCompleted = isCompleted
                updatedChallenge.dateCompleted = isCompleted ? Date() : nil
                updatedChallenges[index] = updatedChallenge
                
                if isCompleted {
                    UserDefaultsManager.shared.updateTotalScore(challenge.reward)
                }
            }
        }
        
        // Ažuriraj dnevne izazove
        for (index, challenge) in updatedDailyChallenges.enumerated() {
            if challenge.isCompleted { continue }
            
            var newProgress = challenge.progress
            var isCompleted = false
            
            switch challenge.type {
            case .score:
                newProgress = gameScore
                isCompleted = gameScore >= challenge.target
            case .combo:
                newProgress = maxCombo
                isCompleted = maxCombo >= challenge.target
            case .level:
                newProgress = level
                isCompleted = level >= challenge.target
            case .powerUps:
                newProgress = powerUpsUsed
                isCompleted = powerUpsUsed >= challenge.target
            case .streak:
                newProgress = streak
                isCompleted = streak >= challenge.target
            case .time:
                newProgress = Int(timePlayed / 60)
                isCompleted = newProgress >= challenge.target
            }
            
            if newProgress != challenge.progress || isCompleted {
                var updatedChallenge = challenge
                updatedChallenge.progress = newProgress
                updatedChallenge.isCompleted = isCompleted
                updatedChallenge.dateCompleted = isCompleted ? Date() : nil
                updatedDailyChallenges[index] = updatedChallenge
                
                if isCompleted {
                    UserDefaultsManager.shared.updateTotalScore(challenge.reward)
                }
            }
        }
        
        activeChallenges = updatedChallenges
        dailyChallenges = updatedDailyChallenges
        saveChallenges()
    }
    
    func updateDailyProgress(score: Int, maxCombo: Int, level: Int) {
        updateProgress(
            gameScore: score,
            maxCombo: maxCombo,
            level: level,
            powerUpsUsed: 0,
            streak: 0,
            timePlayed: 0
        )
    }
    
    private func loadChallenges() {
        if let data = defaults.data(forKey: challengesKey),
           let decoded = try? JSONDecoder().decode([Challenge].self, from: data) {
            challenges = decoded
        }
        
        if let data = defaults.data(forKey: activeChallengesKey),
           let decoded = try? JSONDecoder().decode([Challenge].self, from: data) {
            activeChallenges = decoded
        }
        
        if let data = defaults.data(forKey: dailyChallengesKey),
           let decoded = try? JSONDecoder().decode([Challenge].self, from: data) {
            dailyChallenges = decoded
        }
        
        dailyReward = defaults.integer(forKey: dailyRewardKey)
        lastDailyReset = defaults.object(forKey: lastDailyResetKey) as? Date
    }
    
    private func saveChallenges() {
        if let encoded = try? JSONEncoder().encode(challenges) {
            defaults.set(encoded, forKey: challengesKey)
        }
        
        if let encoded = try? JSONEncoder().encode(activeChallenges) {
            defaults.set(encoded, forKey: activeChallengesKey)
        }
        
        if let encoded = try? JSONEncoder().encode(dailyChallenges) {
            defaults.set(encoded, forKey: dailyChallengesKey)
        }
        
        defaults.set(dailyReward, forKey: dailyRewardKey)
        defaults.set(lastDailyReset, forKey: lastDailyResetKey)
    }
    
    func resetChallenges() {
        challenges = []
        activeChallenges = []
        dailyChallenges = []
        dailyReward = 0
        lastDailyReset = nil
        generateNewChallenges()
        resetDailyChallenges()
    }
    
    func generateNewChallenges() {
        activeChallenges = [
            createChallenge(
                type: .score,
                target: 1000,
                reward: 100,
                title: "Beginner",
                description: "Score 1000 points"
            ),
            createChallenge(
                type: .combo,
                target: 3,
                reward: 50,
                title: "Combo Master",
                description: "Achieve 3x combo"
            ),
            createChallenge(
                type: .powerUps,
                target: 5,
                reward: 75,
                title: "Power-up Collector",
                description: "Use 5 power-ups"
            )
        ]
        saveChallenges()
    }
    
    private func createChallenge(type: ChallengeType, target: Int, reward: Int, title: String, description: String) -> Challenge {
        Challenge(
            id: UUID(),
            title: title,
            description: description,
            type: type,
            target: target,
            reward: reward
        )
    }
} 