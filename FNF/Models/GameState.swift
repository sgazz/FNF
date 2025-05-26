import Foundation
import SwiftUI
import Combine

struct Position: Equatable {
    var row: Int
    var column: Int
}

enum PowerUpType: Int, CaseIterable {
    case multiplier = -1  // ×2
    case randomizer = -2  // 🎲
    case clearRow = -3    // →
    case clearColumn = -4 // ↓
    
    var symbol: String {
        switch self {
        case .multiplier: return "×2"
        case .randomizer: return "🎲"
        case .clearRow: return "→"
        case .clearColumn: return "↓"
        }
    }
}

class GameState: ObservableObject {
    static let rows = 10
    static let columns = 6
    
    @Published var board: [[Int]] = Array(repeating: Array(repeating: 0, count: columns), count: rows)
    @Published var fallingNumber: Int = 0
    @Published var nextNumber: Int = 0
    @Published var fallingPosition: Position = Position(row: 0, column: 2)
    @Published var score: Int = 0
    @Published var level: Int = 1
    @Published var targetNumber: Int = 10
    @Published var isGameOver: Bool = false
    @Published var currentCombos: Int = 0
    @Published var comboMultiplier: Int = 1
    @Published var selectedMode: ScoreManager.GameMode = .classic
    @Published var remainingTime: Int?
    @Published var maxCombo: Int = 0
    @Published var lastPowerUp: PowerUpType?
    
    private var timer: Timer?
    private var gameTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var startTime: Date?
    private var powerUpsUsed: [PowerUpType: Int] = [:]
    private var gameStartTime: Date?
    private var mistakes: Int = 0
    private var currentStreak: Int = 0
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: 0, count: Self.columns), count: Self.rows)
        fallingPosition = Position(row: 0, column: 2)
        score = 0
        level = 1
        maxCombo = 0
        currentCombos = 0
        comboMultiplier = 1
        isGameOver = false
        
        let settings = ScoreManager.shared.getModeSettings(selectedMode)
        targetNumber = settings.targetNumber
        remainingTime = settings.timeLimit
        
        nextNumber = generateNextNumber()
        fallingNumber = generateNextNumber()
        
        startGameTimer()
        powerUpsUsed = [:]
        gameStartTime = Date()
    }
    
    private func startGameTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateFallingNumber()
        }
        
        if remainingTime != nil {
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime == nil || self.remainingTime! <= 0 {
                    self.endGame()
                } else {
                    self.remainingTime! -= 1
                }
            }
        }
    }
    
    func generateNextNumber() -> Int {
        if Double.random(in: 0...1) < 0.2 {
            return PowerUpType.allCases.randomElement()!.rawValue
        }
        return Int.random(in: 1...9)
    }
    
    func moveLeft() {
        guard fallingPosition.column > 0 else { return }
        fallingPosition.column -= 1
        SoundManager.shared.playSound("move")
    }
    
    func moveRight() {
        guard fallingPosition.column < Self.columns - 1 else { return }
        fallingPosition.column += 1
        SoundManager.shared.playSound("move")
    }
    
    func rotate() {
        let temp = fallingNumber
        fallingNumber = nextNumber
        nextNumber = temp
        SoundManager.shared.playSound("rotate")
    }
    
    func checkCollision() -> Bool {
        let nextRow = fallingPosition.row + 1
        
        if nextRow >= Self.rows {
            return true
        }
        
        return board[nextRow][fallingPosition.column] != 0
    }
    
    func updateFallingNumber() {
        if checkCollision() {
            // Fiksiraj broj na tabli
            board[fallingPosition.row][fallingPosition.column] = fallingNumber
            SoundManager.shared.playSound("drop")
            
            // Proveri redove i kolone
            checkRowsAndColumns()
            
            // Postavi novi padajući broj
            fallingPosition = Position(row: 0, column: 2)
            fallingNumber = nextNumber
            nextNumber = generateNextNumber()
            
            // Proveri game over
            if checkCollision() {
                endGame()
            }
        } else {
            fallingPosition.row += 1
        }
    }
    
    func checkRowsAndColumns() {
        var clearedLines = 0
        
        // Proveri redove
        for row in 0..<Self.rows {
            let sum = board[row].reduce(0) { $0 + abs($1) }
            if sum == targetNumber {
                clearRow(row)
                clearedLines += 1
            }
        }
        
        // Proveri kolone
        for col in 0..<Self.columns {
            var sum = 0
            for row in 0..<Self.rows {
                sum += abs(board[row][col])
            }
            if sum == targetNumber {
                clearColumn(col)
                clearedLines += 1
            }
        }
        
        // Ažuriraj kombo i skor
        if clearedLines > 0 {
            currentCombos += 1
            maxCombo = max(maxCombo, currentCombos)
            comboMultiplier = min(currentCombos, 5)
            
            var points = clearedLines * 100 * comboMultiplier
            if selectedMode == .timeAttack {
                points = Int(Double(points) * 1.5) // 50% više poena u time attack modu
            }
            
            score += points
            
            // Proveri napredak nivoa
            if score >= level * 500 {
                level += 1
                if selectedMode != .zen {
                    targetNumber = min(targetNumber + 2, 20)
                }
                EffectManager.shared.showLevelUp(level)
            }
            
            // Zvuk i efekat za kombo
            if currentCombos > 1 {
                SoundManager.shared.playSound("combo")
                EffectManager.shared.showCombo(comboMultiplier)
            }
        } else {
            currentCombos = 0
            comboMultiplier = 1
        }
    }
    
    func clearRow(_ row: Int) {
        for col in 0..<Self.columns {
            board[row][col] = 0
        }
    }
    
    func clearColumn(_ col: Int) {
        for row in 0..<Self.rows {
            board[row][col] = 0
        }
    }
    
    func handlePowerUp(_ powerUp: PowerUpType, at position: Position) {
        lastPowerUp = powerUp
        SoundManager.shared.playSound("powerup")
        
        // Ažuriraj broj korišćenih power-upova
        powerUpsUsed[powerUp, default: 0] += 1
        
        switch powerUp {
        case .multiplier:
            comboMultiplier *= 2
        case .randomizer:
            for row in 0..<Self.rows {
                for col in 0..<Self.columns {
                    if board[row][col] > 0 {
                        board[row][col] = Int.random(in: 1...9)
                    }
                }
            }
        case .clearRow:
            clearRow(position.row)
        case .clearColumn:
            clearColumn(position.column)
        }
    }
    
    private func endGame() {
        isGameOver = true
        gameTimer?.invalidate()
        gameTimer = nil
        
        // Ažuriraj statistiku
        let isPerfect = mistakes == 0
        let gameTime = Date().timeIntervalSince(gameStartTime ?? Date())
        
        PlayerStatsManager.shared.updateStats(
            gameScore: score,
            playTime: gameTime,
            powerUps: powerUpsUsed,
            isPerfect: isPerfect,
            mistakes: mistakes
        )
        
        PlayerStatsManager.shared.updateGameStats(
            maxCombo: maxCombo,
            maxLevel: level
        )
        
        // Ažuriraj izazove
        ChallengeManager.shared.updateProgress(
            gameScore: score,
            maxCombo: maxCombo,
            level: level,
            powerUpsUsed: powerUpsUsed.values.reduce(0, +),
            streak: currentStreak,
            timePlayed: gameTime
        )
        
        // Ažuriraj dostignuća
        AchievementManager.shared.updateProgress(
            totalScore: PlayerStatsManager.shared.stats.totalScore,
            highScore: PlayerStatsManager.shared.stats.highScore,
            gamesPlayed: PlayerStatsManager.shared.stats.gamesPlayed,
            playTime: Int(PlayerStatsManager.shared.stats.totalPlayTime),
            maxCombo: maxCombo,
            maxLevel: level,
            powerUpsUsed: powerUpsUsed.values.reduce(0, +),
            perfectGames: isPerfect ? 1 : 0
        )
        
        // Zvuk za kraj igre
        SoundManager.shared.playSound("gameover")
    }
    
    deinit {
        timer?.invalidate()
        gameTimer?.invalidate()
    }
} 