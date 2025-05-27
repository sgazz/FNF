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
    @Published var isFastFalling: Bool = false
    @Published var perfectGames: Int = 0
    @Published var lastComboTime: Date?
    
    private var timer: Timer?
    private var gameTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var startTime: Date?
    private var powerUpsUsed: [PowerUpType: Int] = [:]
    private var gameStartTime: Date?
    private var mistakes: Int = 0
    private var currentStreak: Int = 0
    private let powerUpChance: Double = 0.1 // Smanjena verovatnoća na 10%
    private let comboTimeout: TimeInterval = 5.0 // 5 sekundi za resetovanje komba
    
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
        // Povećavamo verovatnoću za power-up na 20% radi testiranja
        if Double.random(in: 0...1) < 0.2 {
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
        // Proveri koliziju nakon pomeranja
        if checkCollision() {
            fallingPosition.column += 1 // Vrati se na prethodnu poziciju
        }
        SoundManager.shared.playSound("move")
    }
    
    func moveRight() {
        guard fallingPosition.column < Self.columns - 1 else { return }
        fallingPosition.column += 1
        // Proveri koliziju nakon pomeranja
        if checkCollision() {
            fallingPosition.column -= 1 // Vrati se na prethodnu poziciju
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
        // Proveri da li je trenutna pozicija van table
        if fallingPosition.row >= Self.rows || fallingPosition.column >= Self.columns {
            return true
        }
        
        // Proveri da li je trenutna pozicija prazna
        if board[fallingPosition.row][fallingPosition.column] != 0 {
            return true
        }
        
        // Proveri da li je sledeća pozicija van table
        let nextRow = fallingPosition.row + 1
        if nextRow >= Self.rows {
            return true
        }
        
        // Proveri da li je sledeća pozicija prazna
        return board[nextRow][fallingPosition.column] != 0
    }
    
    func updateFallingNumber() {
        // Proveri da li je trenutna pozicija van table
        if fallingPosition.row >= Self.rows || fallingPosition.column >= Self.columns {
            endGame()
            return
        }
        
        if checkCollision() {
            // Proveri da li je trenutna pozicija prazna
            if board[fallingPosition.row][fallingPosition.column] == 0 {
                print("Collision detected at position: \(fallingPosition)") // Debug print
                print("Falling number: \(fallingNumber)") // Debug print
                
                // Fiksiraj broj na tabli
                board[fallingPosition.row][fallingPosition.column] = fallingNumber
                print("Board after placing number:") // Debug print
                printBoard() // Debug print
                
                // Proveri da li je power-up
                if fallingNumber < 0, let powerUp = PowerUpType(rawValue: fallingNumber) {
                    handlePowerUp(powerUp, at: fallingPosition)
                }
                
                SoundManager.shared.playSound("drop")
                
                // Proveri redove i kolone dok ima šta za čišćenje
                var hasClearedLines = true
                while hasClearedLines {
                    hasClearedLines = checkRowsAndColumns()
                }
                
                // Postavi novi padajući broj
                fallingPosition = Position(row: 0, column: 2)
                fallingNumber = nextNumber
                nextNumber = generateNextNumber()
                
                // Proveri game over
                if checkCollision() {
                    endGame()
                }
            } else {
                // Ako trenutna pozicija nije prazna, pomeri broj na sledeću poziciju
                fallingPosition.row += 1
                // Proveri da li je nova pozicija van table
                if fallingPosition.row >= Self.rows {
                    endGame()
                }
            }
        } else {
            fallingPosition.row += 1
            // Proveri da li je nova pozicija van table
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
        
        // Proveri sve moguće horizontalne sume
        for row in 0..<Self.rows {
            for startCol in 0..<Self.columns {
                var sum = 0
                var endCol = startCol
                
                // Saberi brojeve dok ne dostigneš ciljni broj ili ne dođeš do kraja reda
                while endCol < Self.columns {
                    if board[row][endCol] > 0 {
                        sum += board[row][endCol]
                        if sum == targetNumber {
                            // Očisti sve brojeve u ovom nizu
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
        
        // Proveri sve moguće vertikalne sume
        for col in 0..<Self.columns {
            for startRow in 0..<Self.rows {
                var sum = 0
                var endRow = startRow
                
                // Saberi brojeve dok ne dostigneš ciljni broj ili ne dođeš do kraja kolone
                while endRow < Self.rows {
                    if board[endRow][col] > 0 {
                        sum += board[endRow][col]
                        if sum == targetNumber {
                            // Očisti sve brojeve u ovom nizu
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
        
        // Ažuriraj kombo i skor
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
            
            // Proveri napredak nivoa
            if score >= level * 500 {
                level += 1
                if selectedMode != .zen {
                    targetNumber = min(targetNumber + 2, 20)
                }
                EffectManager.shared.showLevelUp(level)
                print("Level up! New level: \(level), new target: \(targetNumber)") // Debug print
            }
            
            // Zvuk i efekat za kombo
            if currentCombos > 1 {
                SoundManager.shared.playSound("combo")
                EffectManager.shared.showCombo(comboMultiplier)
                print("Combo: \(currentCombos)x, multiplier: \(comboMultiplier)") // Debug print
            }
            
            return true // Vraćamo true ako je bilo čišćenja
        } else {
            // Resetuj kombo ako je prošlo više od 5 sekundi
            if let lastCombo = lastComboTime, Date().timeIntervalSince(lastCombo) > comboTimeout {
                currentCombos = 0
                comboMultiplier = 1
                print("Combo reset due to timeout") // Debug print
            }
            return false // Vraćamo false ako nije bilo čišćenja
        }
    }
    
    func clearRow(_ row: Int) {
        print("Clearing row \(row): \(board[row])") // Debug print
        for col in 0..<Self.columns {
            board[row][col] = 0
        }
        print("Row \(row) cleared: \(board[row])") // Debug print
    }
    
    func clearColumn(_ col: Int) {
        print("Clearing column \(col)") // Debug print
        for row in 0..<Self.rows {
            print("Column \(col) value at row \(row): \(board[row][col])") // Debug print
            board[row][col] = 0
        }
        print("Column \(col) cleared") // Debug print
    }
    
    func handlePowerUp(_ powerUp: PowerUpType, at position: Position) {
        print("Activating power-up: \(powerUp.symbol) at position: \(position)") // Debug print
        lastPowerUp = powerUp
        SoundManager.shared.playSound("powerup")
        
        // Ažuriraj broj korišćenih power-upova
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
            clearRow(position.row)
        case .clearColumn:
            print("Applying clear column effect") // Debug print
            clearColumn(position.column)
        }
    }
    
    func toggleFastFall() {
        isFastFalling.toggle()
        if isFastFalling {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.updateFallingNumber()
            }
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.updateFallingNumber()
            }
        }
    }
    
    private func endGame() {
        isGameOver = true
        timer?.invalidate()
        gameTimer?.invalidate()
        
        // Proveri da li je ovo savršena igra
        if mistakes == 0 && score > 0 {
            perfectGames += 1
            EffectManager.shared.showAchievement(Achievement(
                id: "perfect_game",
                title: "Savršena igra!",
                description: "Završio si igru bez grešaka",
                icon: "star.fill",
                reward: 1000,
                isUnlocked: true,
                dateUnlocked: Date(),
                category: .special
            ))
        }
        
        // Ažuriraj statistiku
        let playTime = gameStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let totalPowerUpsUsed = powerUpsUsed.values.reduce(0, +)
        
        AchievementManager.shared.updateProgress(
            totalScore: score,
            highScore: UserDefaultsManager.shared.getHighScore(),
            gamesPlayed: 1,
            playTime: Int(playTime),
            maxCombo: maxCombo,
            maxLevel: level,
            powerUpsUsed: totalPowerUpsUsed,
            perfectGames: mistakes == 0 ? 1 : 0
        )
        
        // Ažuriraj izazove
        ChallengeManager.shared.updateProgress(
            gameScore: score,
            maxCombo: maxCombo,
            level: level,
            powerUpsUsed: totalPowerUpsUsed,
            streak: currentStreak,
            timePlayed: playTime
        )
        
        // Ažuriraj dostignuća
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
        
        // Zvuk za kraj igre
        SoundManager.shared.playSound("gameover")
    }
    
    deinit {
        timer?.invalidate()
        gameTimer?.invalidate()
    }
} 