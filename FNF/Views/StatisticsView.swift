import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var highScores = UserDefaultsManager.shared.getHighScores()
    @StateObject private var playerStats = PlayerStatsManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("High Scores")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    ForEach(highScores.indices, id: \.self) { index in
                        StatRow(
                            title: "\(index + 1). place",
                            value: "\(highScores[index])"
                        )
                        .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                Section(header: Text("Game Statistics")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(
                        title: "Total Games Played",
                        value: "\(playerStats.stats.gamesPlayed)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Total Play Time",
                        value: TimeFormatter.format(playerStats.stats.totalPlayTime)
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Total Score",
                        value: "\(playerStats.stats.totalScore)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "High Score",
                        value: "\(playerStats.stats.highScore)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                Section(header: Text("Performance")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(
                        title: "Highest Combo",
                        value: "\(playerStats.stats.maxCombo)x"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Highest Level",
                        value: "\(playerStats.stats.maxLevel)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Perfect Games",
                        value: "\(playerStats.stats.perfectGames)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Total Mistakes",
                        value: "\(playerStats.stats.mistakes)"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                Section(header: Text("Averages")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(
                        title: "Average Score",
                        value: "\(playerStats.getAverageScore())"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Average Play Time",
                        value: TimeFormatter.format(playerStats.getAveragePlayTime())
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                if let mostUsedPowerUp = playerStats.getMostUsedPowerUp() {
                    Section(header: Text("Power-ups")
                                    .font(.headline)
                                    .foregroundColor(.yellow)
                                    .padding(.vertical, 5)
                        ) {
                        StatRow(
                            title: "Most Used Power-up",
                            value: "\(mostUsedPowerUp.symbol) (\(mostUsedPowerUp.count) times)"
                        )
                        .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                if let lastPlayed = playerStats.stats.lastPlayed {
                    Section(header: Text("Last Game")
                                    .font(.headline)
                                    .foregroundColor(.yellow)
                                    .padding(.vertical, 5)
                        ) {
                        StatRow(
                            title: "Date",
                            value: formatDate(lastPlayed)
                        )
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    StatisticsView()
} 