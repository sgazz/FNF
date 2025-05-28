import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var statsManager = PlayerStatsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Basic Statistics
                Section(header: Text("Basic Statistics").font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(title: "Total Score", value: "\(statsManager.stats.totalScore)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "High Score", value: "\(statsManager.stats.highScore)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Games Played", value: "\(statsManager.stats.gamesPlayed)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Average Score", value: "\(statsManager.getAverageScore())")
                        .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Game Statistics
                Section(header: Text("Game Statistics").font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(title: "Max Combo", value: "\(statsManager.stats.maxCombo)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Highest Level", value: "\(statsManager.stats.maxLevel)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Perfect Games", value: "\(statsManager.stats.perfectGames)")
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Perfect Game %", value: String(format: "%.1f%%", statsManager.getPerfectGamePercentage()))
                        .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Power-ups Statistics
                Section(header: Text("Power-ups").font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    ForEach(statsManager.stats.powerUpsUsed.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                        StatRow(title: "\(key)", value: "\(value)")
                            .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                // Time Statistics
                Section(header: Text("Time").font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(title: "Total Time", value: formatTime(statsManager.stats.totalPlayTime))
                        .listRowBackground(Color.black.opacity(0.3))
                    StatRow(title: "Average Time", value: formatTime(statsManager.getAveragePlayTime()))
                        .listRowBackground(Color.black.opacity(0.3))
                    if let lastPlayed = statsManager.stats.lastPlayed {
                        StatRow(title: "Last Played", value: formatDate(lastPlayed))
                            .listRowBackground(Color.black.opacity(0.3))
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
                    .foregroundColor(.white)
                }
            }
            .background(Color.black.ignoresSafeArea())
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