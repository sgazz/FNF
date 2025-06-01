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
    @State private var showingChallenges = false
    @State private var showingRules = false
    @State private var isMuted = false
    @State private var isShowingMainMenu = true
    
    // Haptički feedback
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            // Background - updated to darker gradient
            RadialGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black]),
                center: .center,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            if isShowingMainMenu {
                VStack(spacing: 40) {
                    Text("Fall Number...Fall!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                        .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding(.top, 60)
                    
                    Button("Rules") {
                        showingRules = true
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button("Mode Selection") {
                        showingModeSelection = true
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button("Statistics") {
                        showingStatistics = true
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button("Achievements") {
                        showingAchievements = true
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button("Challenges") {
                        showingChallenges = true
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button("Start Game") {
                        isShowingMainMenu = false
                        gameState.resetGame()
                        gameState.startGameTimer()
                    }
                    .font(.title2)
                    .frame(width: 250)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                    )
                    .foregroundColor(.white)
                    
                    Button(action: {
                        isMuted.toggle()
                        SoundManager.shared.setMute(isMuted)
                    }) {
                        HStack {
                            Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                                .font(.title2)
                            Text(isMuted ? "Unmute" : "Mute")
                                .font(.title2)
                        }
                        .frame(width: 250)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                )
                                .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                        )
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
            } else {
                VStack(spacing: 20) {
                    // Top menu - remove system icons if they are replaced by main menu buttons
                    HStack {
                        Spacer()
                    }
                    .padding()
                    
                    // Score and numbers - apply gold border and glow
                    HStack {
                        VStack {
                            Text("Score: \(gameState.score)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            Text("Level: \(gameState.level)")
                                .font(.title2)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Next:")
                                .font(.title2)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            if gameState.nextNumber < 0 {
                                Text(PowerUpType(rawValue: gameState.nextNumber)?.symbol ?? "")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            } else {
                                Text("\(gameState.nextNumber)")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Target: \(gameState.targetNumber)")
                                .font(.title2)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                            Text("Combo: \(gameState.currentCombos)")
                                .font(.title2)
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.4)) // Tamnija pozadina
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3) // Zlatna ivica
                            )
                            .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0) // Zlatni sjaj
                    )
                    .padding(.horizontal)
                    
                    // Remaining time (only for time attack mode)
                    if let remainingTime = gameState.remainingTime {
                        Text(timeString(from: remainingTime))
                            .font(.title)
                            .bold()
                            .foregroundColor(remainingTime <= 30 ? .red : .primary)
                    }
                    
                    // Game board
                    GameBoardView(gameState: gameState)
                        .frame(maxHeight: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.50)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                    
                    // Controls - apply gold border and glow to buttons
                    HStack(spacing: 30) {
                        Button(action: {
                            impactGenerator.impactOccurred()
                            gameState.moveLeft()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 40, weight: .bold))
                                .padding(25)
                                .background(Circle().fill(Color.black.opacity(0.4)))
                                .overlay(
                                    Circle()
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                )
                                .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
                        }
                        
                        VStack(spacing: 15) {
                            Button(action: {
                                impactGenerator.impactOccurred()
                                gameState.togglePause()
                            }) {
                                Image(systemName: gameState.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                                    .shadow(color: .yellow.opacity(0.6), radius: 5, x: 0, y: 0)
                            }
                            
                            Button(action: {
                                impactGenerator.impactOccurred()
                                gameState.rotate()
                            }) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.system(size: 30, weight: .bold))
                                    .padding(20)
                                    .background(Circle().fill(Color.black.opacity(0.4)))
                                    .overlay(
                                        Circle()
                                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                    )
                                    .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
                            }
                            
                            Button(action: {
                                impactGenerator.impactOccurred()
                                gameState.toggleFastFall()
                            }) {
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 30, weight: .bold))
                                    .padding(20)
                                    .background(Circle().fill(Color.black.opacity(0.4)))
                                    .overlay(
                                        Circle()
                                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                    )
                                    .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
                            }
                        }
                        
                        Button(action: {
                            impactGenerator.impactOccurred()
                            gameState.moveRight()
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 40, weight: .bold))
                                .padding(25)
                                .background(Circle().fill(Color.black.opacity(0.4)))
                                .overlay(
                                    Circle()
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                )
                                .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
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
                    }, isShowingMainMenu: $isShowingMainMenu)
                }
                
                // Pause overlay
                if gameState.isPaused {
                    ZStack {
                        Color.black.opacity(0.7)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            Text("PAUSED")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                                .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 5)
                            
                            Button(action: {
                                impactGenerator.impactOccurred()
                                gameState.togglePause()
                            }) {
                                Text("Resume")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                    .frame(width: 200)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                            )
                                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                                    )
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                impactGenerator.impactOccurred()
                                gameState.isPaused = false
                                isShowingMainMenu = true
                            }) {
                                Text("Main Menu")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                    .frame(width: 200)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                            )
                                            .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
                
                // Vizuelni efekti
                if effectManager.showingCombo {
                    ComboEffectView(multiplier: effectManager.comboMultiplier)
                        .offset(y: -UIScreen.main.bounds.height * 0.3)
                        .opacity(effectManager.opacity)
                }
                
                if effectManager.showingLevelUp {
                    LevelUpEffectView(level: effectManager.level)
                        .offset(y: -UIScreen.main.bounds.height * 0.3)
                        .opacity(effectManager.opacity)
                }
                
                if effectManager.showingScore {
                    ScoreEffectView(score: effectManager.score)
                        .offset(y: -UIScreen.main.bounds.height * 0.3)
                        .opacity(effectManager.opacity)
                }
                
                if effectManager.showingAchievement {
                    AchievementEffectView(achievement: effectManager.achievement!)
                        .offset(y: -UIScreen.main.bounds.height * 0.3)
                        .opacity(effectManager.opacity)
                }
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
        .sheet(isPresented: $showingChallenges) {
            ChallengesView()
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
            RoundedRectangle(cornerRadius: 4) // Manje zaobljeni uglovi
                .fill(cellColor.opacity(value == 0 ? 0.1 : 0.6)) // Smanjena neprovidnost pozadine ćelije, malo tamnije
                .overlay(
                    RoundedRectangle(cornerRadius: 4) // Manji zaobljeni uglovi za ćelije
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: value == 0 ? 1 : 2) // Zlatna ivica (tanja za prazne ćelije), manja neprovidnost gradijenta
                )
                .shadow(color: .yellow.opacity(value == 0 ? 0.1 : 0.4), radius: value == 0 ? 3 : 6, x: 0, y: 0) // Zlatni sjaj (manji za prazne ćelije), manja neprovidnost sjaja
            
            if value != 0 {
                if value < 0 {
                    Text(PowerUpType(rawValue: value)?.symbol ?? "")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white) // Beli tekst za brojeve i power-upe
                } else {
                    Text("\(value)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var cellColor: Color {
        switch value {
        case 0:
            return Color.gray // Prazne ćelije su tamnije sive
        case 1:
            return .green
        case 2:
            return .blue
        case 3:
            return .red
        case 4:
            return .orange
        case 5:
            return .purple
        case 6:
            return .cyan
        case 7:
            return .pink
        case 8:
            return .teal
        case 9:
            return .indigo
        default: // Power-ups
            return .gray // Power-upi će imati sivu pozadinu sa zlatnom ivicom
        }
    }
}

struct GameOverView: View {
    let score: Int
    let onPlayAgain: () -> Void
    @Binding var isShowingMainMenu: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Game Over!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                    .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 5)
                
                Text("Score: \(score)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2)
                
                Button(action: onPlayAgain) {
                    Text("Play Again")
                        .font(.title2)
                        .bold()
                        .frame(width: 250)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                )
                                .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                        )
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    onPlayAgain()
                    isShowingMainMenu = true
                }) {
                    Text("Main Menu")
                        .font(.title2)
                        .bold()
                        .frame(width: 250)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                )
                                .shadow(color: .yellow.opacity(0.8), radius: 15, x: 0, y: 0)
                        )
                        .foregroundColor(.white)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                    )
                    .shadow(color: .yellow.opacity(0.6), radius: 20, x: 0, y: 0)
            )
        }
    }
}

#Preview {
    ContentView()
} 
