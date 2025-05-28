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
                                    .foregroundColor(.white)
                                Text(modeDescription(for: mode))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if mode == selectedMode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: mode == selectedMode ? 3 : 1)
                                )
                                .shadow(color: .yellow.opacity(mode == selectedMode ? 0.6 : 0.3), radius: mode == selectedMode ? 10 : 5, x: 0, y: 0)
                        )
                    }
                    .listRowBackground(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("Select Mode")
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
    
    private func modeTitle(for mode: ScoreManager.GameMode) -> String {
        switch mode {
        case .classic:
            return "Classic Mode"
        case .timeAttack:
            return "Time Attack Mode"
        case .zen:
            return "Zen Mode"
        }
    }
    
    private func modeDescription(for mode: ScoreManager.GameMode) -> String {
        switch mode {
        case .classic:
            return "Standard game mode with target number 10"
        case .timeAttack:
            return "Play against time - 3 minutes for highest score"
        case .zen:
            return "Relaxing mode with lower target number"
        }
    }
}

#Preview {
    ModeSelectionView(selectedMode: .constant(.classic))
} 