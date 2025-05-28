import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var statsManager = PlayerStatsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Basic Statistics
                Section(header: Text("Basic Statistics")) {
                    StatRow(title: "Total Score", value: "\(statsManager.stats.totalScore)")
                    StatRow(title: "High Score", value: "\(statsManager.stats.highScore)")
                    StatRow(title: "Games Played", value: "\(statsManager.stats.gamesPlayed)")
                    StatRow(title: "Average Score", value: "\(statsManager.getAverageScore())")
                }
                
                // Game Statistics
                Section(header: Text("Game Statistics")) {
                    StatRow(title: "Max Combo", value: "\(statsManager.stats.maxCombo)")
                    StatRow(title: "Highest Level", value: "\(statsManager.stats.maxLevel)")
                    StatRow(title: "Perfect Games", value: "\(statsManager.stats.perfectGames)")
                    StatRow(title: "Perfect Game %", value: String(format: "%.1f%%", statsManager.getPerfectGamePercentage()))
                }
                
                // Power-ups Statistics
                Section(header: Text("Power-ups")) {
                    ForEach(statsManager.stats.powerUpsUsed.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                        StatRow(title: "\(key)", value: "\(value)")
                    }
                }
                
                // Time Statistics
                Section(header: Text("Time")) {
                    StatRow(title: "Total Time", value: formatTime(statsManager.stats.totalPlayTime))
                    StatRow(title: "Average Time", value: formatTime(statsManager.getAveragePlayTime()))
                    if let lastPlayed = statsManager.stats.lastPlayed {
                        StatRow(title: "Last Played", value: formatDate(lastPlayed))
                    }
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%dh %dm %ds", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%dm %ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    PlayerStatsView()
} 