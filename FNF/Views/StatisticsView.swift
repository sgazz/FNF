import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var highScores = UserDefaultsManager.shared.getHighScores()
    
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
                
                Section(header: Text("Statistics")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    StatRow(
                        title: "Total Games Played",
                        value: "\(UserDefaultsManager.shared.getGamesPlayed())"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Total Play Time",
                        value: TimeFormatter.format(TimeInterval(UserDefaultsManager.shared.getTotalPlayTime() * 60))
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    StatRow(
                        title: "Total Score",
                        value: "\(UserDefaultsManager.shared.getTotalScore())"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                if let lastPlayed = UserDefaultsManager.shared.getLastPlayedDate() {
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