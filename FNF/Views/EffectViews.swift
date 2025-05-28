import SwiftUI

struct ComboEffectView: View {
    let multiplier: Int
    
    var body: some View {
        Text("\(multiplier)x COMBO!")
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 2)
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
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Text("New target: \(level * 2)")
                .font(.title2)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
        }
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
            .shadow(color: .black, radius: 2)
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
                .fill(Color.blue.opacity(0.9))
        )
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
    }
} 