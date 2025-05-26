import SwiftUI

struct ModeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMode: ScoreManager.GameMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach([ScoreManager.GameMode.classic, .timeAttack, .zen], id: \.self) { mode in
                    Button(action: {
                        selectedMode = mode
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(modeTitle(for: mode))
                                    .font(.headline)
                                Text(modeDescription(for: mode))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if mode == selectedMode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Izaberi Mod")
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
    
    private func modeTitle(for mode: ScoreManager.GameMode) -> String {
        switch mode {
        case .classic:
            return "Klasični Mod"
        case .timeAttack:
            return "Mod sa Vremenom"
        case .zen:
            return "Zen Mod"
        }
    }
    
    private func modeDescription(for mode: ScoreManager.GameMode) -> String {
        switch mode {
        case .classic:
            return "Standardni mod igre sa ciljnim brojem 10"
        case .timeAttack:
            return "Igraj protiv vremena - 3 minuta za najviše poena"
        case .zen:
            return "Opuštajući mod sa nižim ciljnim brojem"
        }
    }
}

#Preview {
    ModeSelectionView(selectedMode: .constant(.classic))
} 