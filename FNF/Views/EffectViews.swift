import SwiftUI

struct ComboEffectView: View {
    let multiplier: Int
    
    var body: some View {
        Text("\(multiplier)x COMBO!")
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                    )
                    .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
            )
            .scaleEffect(1.2)
            .transition(.scale.combined(with: .opacity))
    }
}

struct LevelUpEffectView: View {
    let level: Int
    
    var body: some View {
        VStack {
            Text("LEVEL \(level)!")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.yellow)
                .shadow(color: .black, radius: 2)
            
            Text("New target: \(level * 2)")
                .font(.title2)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                )
                .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
        )
        .scaleEffect(1.2)
        .transition(.scale.combined(with: .opacity))
    }
}

struct ScoreEffectView: View {
    let score: Int
    
    var body: some View {
        Text("+\(score)")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(.green)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    )
                    .shadow(color: .yellow.opacity(0.4), radius: 6, x: 0, y: 0)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct AchievementEffectView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text("Achievement Unlocked!")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(achievement.title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Text("+\(achievement.reward) points")
                .font(.title3)
                .foregroundColor(.green)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                )
                .shadow(color: .yellow.opacity(0.7), radius: 10, x: 0, y: 0)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    VStack(spacing: 20) {
        ComboEffectView(multiplier: 3)
        LevelUpEffectView(level: 5)
        ScoreEffectView(score: 1000)
        AchievementEffectView(achievement: Achievement(
            id: "test",
            title: "Test Achievement",
            description: "Test Description",
            icon: "star.fill",
            reward: 100,
            isUnlocked: true,
            dateUnlocked: Date(),
            category: .score
        ))
    }
    .padding()
    .background(Color.black)
} 