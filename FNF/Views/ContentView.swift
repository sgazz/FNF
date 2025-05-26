import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    @StateObject private var effectManager = EffectManager.shared
    @State private var showingGameOver = false
    @State private var showingPowerUpEffect = false
    @State private var powerUpType: PowerUpType?
    @State private var showingModeSelection = false
    @State private var showingAchievements = false
    @State private var showingStatistics = false
    @State private var showingPlayerStats = false
    @State private var showingChallenges = false
    @State private var showingStats = false
    @State private var showingRules = false
    @State private var isMuted = false
    
    // Haptički feedback
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            // Pozadina
            RadialGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Gornji meni
                HStack {
                    Button {
                        showingChallenges = true
                    } label: {
                        Image(systemName: "trophy.fill")
                            .font(.title2)
                    }
                    
                    Button {
                        showingAchievements = true
                    } label: {
                        Image(systemName: "star.fill")
                            .font(.title2)
                    }
                    
                    Button {
                        showingStats = true
                    } label: {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                    }
                    
                    Button {
                        showingRules = true
                    } label: {
                        Image(systemName: "book.fill")
                            .font(.title2)
                    }
                    
                    Button(action: { showingModeSelection = true }) {
                        Image(systemName: "gamecontroller")
                            .font(.title2)
                    }
                    Spacer()
                    Button(action: { showingStatistics = true }) {
                        Image(systemName: "chart.bar")
                            .font(.title2)
                    }
                    Spacer()
                    Button(action: {
                        isMuted.toggle()
                        SoundManager.shared.setMute(isMuted)
                    }) {
                        Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                            .font(.title2)
                    }
                }
                .padding()
                
                // Skor i brojevi
                HStack {
                    VStack {
                        Text("Skor: \(gameState.score)")
                            .font(.title2)
                            .bold()
                        Text("Nivo: \(gameState.level)")
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Cilj: \(gameState.targetNumber)")
                            .font(.title3)
                        Text("Kombo: x\(gameState.comboMultiplier)")
                            .font(.title3)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )
                )
                .padding(.horizontal)
                
                // Preostalo vreme (samo za time attack mod)
                if let remainingTime = gameState.remainingTime {
                    Text(timeString(from: remainingTime))
                        .font(.title)
                        .bold()
                        .foregroundColor(remainingTime <= 30 ? .red : .primary)
                }
                
                // Tabla za igru
                GameBoardView(gameState: gameState)
                    .frame(height: 400)
                    .padding()
                
                // Kontrole
                HStack(spacing: 30) {
                    Button(action: {
                        impactGenerator.impactOccurred()
                        gameState.moveLeft()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    
                    Button(action: {
                        impactGenerator.impactOccurred()
                        gameState.rotate()
                    }) {
                        Image(systemName: "arrow.2.squarepath")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    
                    Button(action: {
                        impactGenerator.impactOccurred()
                        gameState.moveRight()
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
                .padding()
            }
            
            // Game Over overlay
            if gameState.isGameOver {
                GameOverView(score: gameState.score, onPlayAgain: {
                    notificationGenerator.notificationOccurred(.success)
                    SoundManager.shared.playSound("gameover")
                    gameState.resetGame()
                    showingGameOver = false
                })
            }
            
            // Vizuelni efekti
            if effectManager.showingCombo {
                ComboEffectView(multiplier: effectManager.comboMultiplier)
                    .transition(.scale.combined(with: .opacity))
            }
            
            if effectManager.showingLevelUp {
                LevelUpEffectView(level: effectManager.level)
                    .transition(.scale.combined(with: .opacity))
            }
            
            if effectManager.showingScore {
                ScoreEffectView(score: effectManager.score)
                    .transition(.scale.combined(with: .opacity))
            }
            
            if effectManager.showingAchievement, let achievement = effectManager.achievement {
                AchievementEffectView(achievement: achievement)
            }
        }
        .sheet(isPresented: $showingModeSelection) {
            ModeSelectionView(selectedMode: $gameState.selectedMode)
        }
        .sheet(isPresented: $showingAchievements) {
            AchievementsView()
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView()
        }
        .sheet(isPresented: $showingPlayerStats) {
            PlayerStatsView()
        }
        .sheet(isPresented: $showingChallenges) {
            ChallengesView()
        }
        .sheet(isPresented: $showingStats) {
            PlayerStatsView()
        }
        .sheet(isPresented: $showingRules) {
            GameRulesView()
        }
        .onChange(of: gameState.score) { oldValue, newValue in
            if newValue > oldValue {
                impactGenerator.impactOccurred()
                SoundManager.shared.playSound("clear")
                effectManager.showScore(newValue - oldValue)
            }
        }
        .onChange(of: gameState.isGameOver) { oldValue, newValue in
            if newValue {
                notificationGenerator.notificationOccurred(.error)
                SoundManager.shared.playSound("gameover")
                showingGameOver = true
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct CellView: View {
    let value: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(cellColor)
            
            if value != 0 {
                if value < 0 {
                    Text(PowerUpType(rawValue: value)?.symbol ?? "")
                        .font(.title2)
                        .bold()
                } else {
                    Text("\(value)")
                        .font(.title2)
                        .bold()
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var cellColor: Color {
        if value == 0 {
            return Color.white.opacity(0.1)
        } else if value < 0 {
            return Color.purple.opacity(0.3)
        } else {
            return Color.blue.opacity(0.3)
        }
    }
}

struct GameOverView: View {
    let score: Int
    let onPlayAgain: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .bold()
                
                Text("Skor: \(score)")
                    .font(.title)
                
                Button(action: onPlayAgain) {
                    Text("Igraj ponovo")
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
        }
    }
}

#Preview {
    ContentView()
} 