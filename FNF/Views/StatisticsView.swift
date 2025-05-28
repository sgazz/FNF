import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var highScores = UserDefaultsManager.shared.getHighScores()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("High Scores")) {
                    ForEach(highScores.indices, id: \.self) { index in
                        StatRow(
                            title: "\(index + 1). place",
                            value: "\(highScores[index])"
                        )
                    }
                }
                
                Section(header: Text("Statistics")) {
                    StatRow(
                        title: "Total Games Played",
                        value: "\(UserDefaultsManager.shared.getGamesPlayed())"
                    )
                    StatRow(
                        title: "Total Play Time",
                        value: TimeFormatter.format(TimeInterval(UserDefaultsManager.shared.getTotalPlayTime() * 60))
                    )
                    StatRow(
                        title: "Total Score",
                        value: "\(UserDefaultsManager.shared.getTotalScore())"
                    )
                }
                
                if let lastPlayed = UserDefaultsManager.shared.getLastPlayedDate() {
                    Section(header: Text("Last Game")) {
                        StatRow(
                            title: "Date",
                            value: formatDate(lastPlayed)
                        )
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