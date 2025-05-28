import SwiftUI

struct AchievementsView: View {
    @StateObject private var achievementManager = AchievementManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: Achievement.Category?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Achievement.Category.allCases, id: \.self) { category in
                    Section(header: Text(category.rawValue)
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                        ForEach(achievementManager.getAchievementsByCategory(category)) { achievement in
                            AchievementRow(achievement: achievement)
                                .listRowBackground(Color.black.opacity(0.3))
                        }
                    }
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("+\(achievement.reward)")
                        .font(.headline)
                        .foregroundColor(.green)
                    if let date = achievement.dateUnlocked {
                        Text(formatDate(date))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: achievement.isUnlocked ? 3 : 1)
                )
                .shadow(color: .yellow.opacity(achievement.isUnlocked ? 0.6 : 0.3), radius: achievement.isUnlocked ? 10 : 5, x: 0, y: 0)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

extension Achievement.Category: CaseIterable {
    static var allCases: [Achievement.Category] {
        [.score, .streak, .powerUps, .time, .special]
    }
}

#Preview {
    AchievementsView()
} 