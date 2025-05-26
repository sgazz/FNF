import SwiftUI

struct PlayerStatsView: View {
    @StateObject private var statsManager = PlayerStatsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Osnovna statistika
                Section(header: Text("Osnovna statistika")) {
                    StatRow(title: "Ukupan skor", value: "\(statsManager.stats.totalScore)")
                    StatRow(title: "Najbolji skor", value: "\(statsManager.stats.highScore)")
                    StatRow(title: "Odigrano partija", value: "\(statsManager.stats.gamesPlayed)")
                    StatRow(title: "Prosečan skor", value: "\(statsManager.getAverageScore())")
                }
                
                // Statistika igre
                Section(header: Text("Statistika igre")) {
                    StatRow(title: "Najveći kombo", value: "\(statsManager.stats.maxCombo)")
                    StatRow(title: "Najviši nivo", value: "\(statsManager.stats.maxLevel)")
                    StatRow(title: "Savršene partije", value: "\(statsManager.stats.perfectGames)")
                    StatRow(title: "Procenat savršenih", value: String(format: "%.1f%%", statsManager.getPerfectGamePercentage()))
                }
                
                // Statistika power-upova
                Section(header: Text("Power-upovi")) {
                    ForEach(statsManager.stats.powerUpsUsed.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                        StatRow(title: "\(key)", value: "\(value)")
                    }
                }
                
                // Vremenska statistika
                Section(header: Text("Vreme")) {
                    StatRow(title: "Ukupno vreme", value: formatTime(statsManager.stats.totalPlayTime))
                    StatRow(title: "Prosečno vreme", value: formatTime(statsManager.getAveragePlayTime()))
                    if let lastPlayed = statsManager.stats.lastPlayed {
                        StatRow(title: "Poslednja igra", value: formatDate(lastPlayed))
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