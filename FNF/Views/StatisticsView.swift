import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var highScores = UserDefaultsManager.shared.getHighScores()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Najbolji skorovi")) {
                    ForEach(highScores.indices, id: \.self) { index in
                        StatRow(
                            title: "\(index + 1). mesto",
                            value: "\(highScores[index])"
                        )
                    }
                }
                
                Section(header: Text("Statistika")) {
                    StatRow(
                        title: "Ukupno odigrano partija",
                        value: "\(UserDefaultsManager.shared.getGamesPlayed())"
                    )
                    StatRow(
                        title: "Ukupno vreme igranja",
                        value: TimeFormatter.format(TimeInterval(UserDefaultsManager.shared.getTotalPlayTime() * 60))
                    )
                    StatRow(
                        title: "Ukupan skor",
                        value: "\(UserDefaultsManager.shared.getTotalScore())"
                    )
                }
                
                if let lastPlayed = UserDefaultsManager.shared.getLastPlayedDate() {
                    Section(header: Text("Poslednja igra")) {
                        StatRow(
                            title: "Datum",
                            value: formatDate(lastPlayed)
                        )
                    }
                }
            }
            .navigationTitle("Statistika")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zatvori") {
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