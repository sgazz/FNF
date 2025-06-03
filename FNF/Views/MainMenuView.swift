import SwiftUI

struct MainMenuView: View {
    @Binding var isShowingMainMenu: Bool
    @Binding var showingRules: Bool
    @Binding var showingModeSelection: Bool
    @Binding var showingStatistics: Bool
    @Binding var showingAchievements: Bool
    @Binding var showingChallenges: Bool
    @Binding var isMuted: Bool
    let onStartGame: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Fall, Number...Fall!")
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
                onStartGame()
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
    }
}

#Preview {
    MainMenuView(
        isShowingMainMenu: .constant(true),
        showingRules: .constant(false),
        showingModeSelection: .constant(false),
        showingStatistics: .constant(false),
        showingAchievements: .constant(false),
        showingChallenges: .constant(false),
        isMuted: .constant(false),
        onStartGame: {}
    )
} 