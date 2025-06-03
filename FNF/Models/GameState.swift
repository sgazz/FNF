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
    case clearRow = -3    // ↔
    case clearColumn = -4 // ↓
    
    var symbol: String {
        switch self {
        case .multiplier: return "×2"
        case .randomizer: return "🎲"
        case .clearRow: return "↔"
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
    @Published var isFastFalling: Bool = false
    @Published var perfectGames: Int = 0
    @Published var lastComboTime: Date?
    @Published var isPaused: Bool = false
    
    private var timer: Timer?
    private var gameTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var startTime: Date?
    private var powerUpsUsed: [PowerUpType: Int] = [:]
    private var gameStartTime: Date?
    private var mistakes: Int = 0
    private var currentStreak: Int = 0
    private let powerUpChance: Double = 0.1 // Reduced probability to 10%
    private let comboTimeout: TimeInterval = 5.0 // 5 seconds to reset combo
    
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
        targetNumber = Int.random(in: 9...20)
        remainingTime = settings.timeLimit
        
        nextNumber = generateNextNumber()
        fallingNumber = generateNextNumber()
        
        powerUpsUsed = [:]
        gameStartTime = Date()
    }
    
    private func getFallSpeed() -> TimeInterval {
        switch level {
        case 1...49:
            return 0.5
        case 50...99:
            return 0.4
        case 100...149:
            return 0.3
        case 150...:
            return 0.2
        default:
            return 0.5
        }
    }
    
    internal func startGameTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: getFallSpeed(), repeats: true) { [weak self] _ in
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
        let powerUpProbability: Double
        if selectedMode == .zen {
            powerUpProbability = 0.2
        } else if level >= 100 {
            powerUpProbability = 0.05
        } else {
            powerUpProbability = 0.1
        }
        
        if Double.random(in: 0...1) < powerUpProbability {
            let powerUp = PowerUpType.allCases.randomElement()!
            print("Generated power-up: \(powerUp.symbol)") // Debug print
            return powerUp.rawValue
        }
        let number = Int.random(in: 1...9)
        print("Generated number: \(number)") // Debug print
        return number
    }
    
    func moveLeft() {
        guard fallingPosition.column > 0 else { return }
        fallingPosition.column -= 1
        // Check collision after movement
        if checkCollision() {
            fallingPosition.column += 1 // Return to previous position
        }
        SoundManager.shared.playSound("move")
    }
    
    func moveRight() {
        guard fallingPosition.column < Self.columns - 1 else { return }
        fallingPosition.column += 1
        // Check collision after movement
        if checkCollision() {
            fallingPosition.column -= 1 // Return to previous position
        }
        SoundManager.shared.playSound("move")
    }
    
    func rotate() {
        let temp = fallingNumber
        fallingNumber = nextNumber
        nextNumber = temp
        SoundManager.shared.playSound("rotate")
    }
    
    func checkCollision() -> Bool {
        // Check if current position is outside the table
        if fallingPosition.row >= Self.rows || fallingPosition.column >= Self.columns {
            return true
        }
        
        // Check if current position is empty
        if board[fallingPosition.row][fallingPosition.column] != 0 {
            return true
        }
        
        // Check if next position is outside the table
        let nextRow = fallingPosition.row + 1
        if nextRow >= Self.rows {
            return true
        }
        
        // Check if next position is empty
        return board[nextRow][fallingPosition.column] != 0
    }
    
    func updateFallingNumber() {
        // Check if current position is outside the table
        if fallingPosition.row >= Self.rows || fallingPosition.column >= Self.columns {
            endGame()
            return
        }
        
        if checkCollision() {
            // Check if current position is empty
            if board[fallingPosition.row][fallingPosition.column] == 0 {
                print("Collision detected at position: \(fallingPosition)") // Debug print
                print("Falling number: \(fallingNumber)") // Debug print
                
                // Fix number on the board
                board[fallingPosition.row][fallingPosition.column] = fallingNumber
                print("Board after placing number:") // Debug print
                printBoard() // Debug print
                
                // Check if power-up
                if fallingNumber < 0, let powerUp = PowerUpType(rawValue: fallingNumber) {
                    handlePowerUp(powerUp, at: fallingPosition)
                }
                
                SoundManager.shared.playSound("drop")
                
                // Check rows and columns until there's nothing to clear
                var hasClearedLines = true
                while hasClearedLines {
                    hasClearedLines = checkRowsAndColumns()
                }
                
                // Set new falling number
                fallingPosition = Position(row: 0, column: 2)
                fallingNumber = nextNumber
                nextNumber = generateNextNumber()
                
                // Reset fast falling for the new number
                isFastFalling = false
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: getFallSpeed(), repeats: true) { [weak self] _ in
                    self?.updateFallingNumber()
                }
                
                // Check game over
                if checkCollision() {
                    endGame()
                }
            } else {
                // If current position is not empty, move number to next position
                fallingPosition.row += 1
                // Check if new position is outside the table
                if fallingPosition.row >= Self.rows {
                    endGame()
                }
            }
        } else {
            fallingPosition.row += 1
            // Check if new position is outside the table
            if fallingPosition.row >= Self.rows {
                endGame()
            }
        }
    }
    
    private func printBoard() {
        for row in 0..<Self.rows {
            var rowString = ""
            for col in 0..<Self.columns {
                let value = board[row][col]
                if value < 0 {
                    rowString += "\(PowerUpType(rawValue: value)?.symbol ?? "?") "
                } else {
                    rowString += "\(value) "
                }
            }
            print(rowString)
        }
    }
    
    func checkRowsAndColumns() -> Bool {
        var clearedLines = 0
        
        // Check all possible horizontal sums
        for row in 0..<Self.rows {
            for startCol in 0..<Self.columns {
                var sum = 0
                var endCol = startCol
                
                // Sum numbers until you reach the target number or reach the end of the row
                while endCol < Self.columns {
                    if board[row][endCol] > 0 {
                        sum += board[row][endCol]
                        if sum == targetNumber {
                            // Clear all numbers in this range
                            for col in startCol...endCol {
                                board[row][col] = 0
                            }
                            clearedLines += 1
                            print("Cleared horizontal line at row \(row) from col \(startCol) to \(endCol)")
                            break
                        } else if sum > targetNumber {
                            break
                        }
                    }
                    endCol += 1
                }
            }
        }
        
        // Check all possible vertical sums
        for col in 0..<Self.columns {
            for startRow in 0..<Self.rows {
                var sum = 0
                var endRow = startRow
                
                // Sum numbers until you reach the target number or reach the end of the column
                while endRow < Self.rows {
                    if board[endRow][col] > 0 {
                        sum += board[endRow][col]
                        if sum == targetNumber {
                            // Clear all numbers in this range
                            for row in startRow...endRow {
                                board[row][col] = 0
                            }
                            clearedLines += 1
                            print("Cleared vertical line at col \(col) from row \(startRow) to \(endRow)")
                            break
                        } else if sum > targetNumber {
                            break
                        }
                    }
                    endRow += 1
                }
            }
        }
        
        // Update combo and score
        if clearedLines > 0 {
            print("Cleared \(clearedLines) lines") // Debug print
            currentCombos += 1
            maxCombo = max(maxCombo, currentCombos)
            comboMultiplier = min(currentCombos, 5)
            lastComboTime = Date()
            
            var points = clearedLines * 100 * comboMultiplier
            if selectedMode == .timeAttack {
                points = Int(Double(points) * 1.5)
            }
            
            score += points
            print("Added \(points) points, new score: \(score)") // Debug print
            
            // Check level progress
            if score >= level * 500 {
                level += 1
                if selectedMode != .zen {
                    targetNumber = Int.random(in: 9...20)
                }
                EffectManager.shared.showLevelUp(level)
                print("Level up! New level: \(level), new target: \(targetNumber)") // Debug print
            }
            
            // Sound and effect for combo
            if currentCombos > 1 {
                SoundManager.shared.playSound("combo")
                EffectManager.shared.showCombo(comboMultiplier)
                print("Combo: \(currentCombos)x, multiplier: \(comboMultiplier)") // Debug print
            }
            
            return true // Return true if there was clearing
        } else {
            // Reset combo if more than 5 seconds have passed
            if let lastCombo = lastComboTime, Date().timeIntervalSince(lastCombo) > comboTimeout {
                currentCombos = 0
                comboMultiplier = 1
                print("Combo reset due to timeout") // Debug print
            }
            return false // Return false if there was no clearing
        }
    }
    
    func clearRow(_ row: Int) -> Int {
        print("Clearing row \(row): \(board[row])") // Debug print
        var clearedSum = 0
        for col in 0..<Self.columns {
            clearedSum += board[row][col]
            board[row][col] = 0
        }
        print("Row \(row) cleared: \(board[row])") // Debug print
        return clearedSum
    }
    
    func clearColumn(_ col: Int) -> Int {
        print("Clearing column \(col)") // Debug print
        var clearedSum = 0
        for row in 0..<Self.rows {
            print("Column \(col) value at row \(row): \(board[row][col])") // Debug print
            clearedSum += board[row][col]
            board[row][col] = 0
        }
        print("Column \(col) cleared") // Debug print
        return clearedSum
    }
    
    func handlePowerUp(_ powerUp: PowerUpType, at position: Position) {
        print("Activating power-up: \(powerUp.symbol) at position: \(position)") // Debug print
        SoundManager.shared.playSound("powerup")
        
        // Update number of used power-ups
        powerUpsUsed[powerUp, default: 0] += 1
        
        switch powerUp {
        case .multiplier:
            print("Applying multiplier effect") // Debug print
            comboMultiplier *= 2
        case .randomizer:
            print("Applying randomizer effect") // Debug print
            for row in 0..<Self.rows {
                for col in 0..<Self.columns {
                    if board[row][col] > 0 {
                        board[row][col] = Int.random(in: 1...9)
                    }
                }
            }
        case .clearRow:
            print("Applying clear row effect") // Debug print
            let clearedSum = clearRow(position.row)
            score += clearedSum // Dodaj zbir obrisanih brojeva na skor
        case .clearColumn:
            print("Applying clear column effect") // Debug print
            let clearedSum = clearColumn(position.column)
            score += clearedSum // Dodaj zbir obrisanih brojeva na skor
        }
    }
    
    func toggleFastFall() {
        isFastFalling = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateFallingNumber()
        }
    }
    
    func togglePause() {
        isPaused.toggle()
        if isPaused {
            timer?.invalidate()
            gameTimer?.invalidate()
        } else {
            startGameTimer()
        }
    }
    
    private func endGame() {
        isGameOver = true
        timer?.invalidate()
        gameTimer?.invalidate()
        
        // Check if this was a perfect game
        if mistakes == 0 && score > 0 {
            perfectGames += 1
            EffectManager.shared.showAchievement(Achievement(
                id: "perfect_game",
                title: "Perfect game!",
                description: "Completed the game without mistakes",
                icon: "star.fill",
                reward: 1000,
                isUnlocked: true,
                dateUnlocked: Date(),
                category: .special
            ))
        }
        
        // Update statistics
        let playTime = gameStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let totalPowerUpsUsed = powerUpsUsed.values.reduce(0, +)
        
        // Update player stats
        PlayerStatsManager.shared.updateStats(
            gameScore: score,
            playTime: playTime,
            powerUps: powerUpsUsed,
            isPerfect: mistakes == 0,
            mistakes: mistakes
        )
        
        // Update game stats
        PlayerStatsManager.shared.updateGameStats(
            maxCombo: maxCombo,
            maxLevel: level
        )
        
        // Update achievements
        AchievementManager.shared.updateProgress(
            totalScore: PlayerStatsManager.shared.stats.totalScore,
            highScore: PlayerStatsManager.shared.stats.highScore,
            gamesPlayed: PlayerStatsManager.shared.stats.gamesPlayed,
            playTime: Int(PlayerStatsManager.shared.stats.totalPlayTime),
            maxCombo: maxCombo,
            maxLevel: level,
            powerUpsUsed: totalPowerUpsUsed,
            perfectGames: mistakes == 0 ? 1 : 0
        )
        
        // Update challenges
        ChallengeManager.shared.updateProgress(
            gameScore: score,
            maxCombo: maxCombo,
            level: level,
            powerUpsUsed: totalPowerUpsUsed,
            streak: currentStreak,
            timePlayed: playTime
        )
        
        // Game over sound
        SoundManager.shared.playSound("gameover")
    }
    
    deinit {
        timer?.invalidate()
        gameTimer?.invalidate()
    }
} 