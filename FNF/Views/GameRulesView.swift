import SwiftUI

struct GameRulesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Basic Rules
                Section(header: Text("Basic Rules")) {
                    RuleRow(
                        title: "Game Board",
                        description: "The game takes place on a board with 10 rows and 6 columns. Each cell can contain a number from 1-9, a power-up, or be empty. Numbers fall from the top of the board and must be placed in empty cells."
                    )
                    RuleRow(
                        title: "Game Objective",
                        description: "Achieve the target number in a row or column to score points. The target number increases with level (starts at 10 and can reach up to 20). Every 500 points advances you to the next level."
                    )
                    RuleRow(
                        title: "Falling Numbers",
                        description: "Numbers fall from the top of the board. You can see the next number that will fall. The chance for a power-up is 10%. Numbers range from 1 to 9."
                    )
                }
                
                // Controls
                Section(header: Text("Controls")) {
                    RuleRow(
                        title: "Movement",
                        description: "Use arrow keys to move numbers left and right within a column. Numbers can only be moved while falling."
                    )
                    RuleRow(
                        title: "Rotation",
                        description: "Use the rotation button to swap the current and next number. This is a key mechanic for planning moves."
                    )
                    RuleRow(
                        title: "Speed Up",
                        description: "Hold the speed button to accelerate the falling number. The falling speed increases 5 times. Use this when you want to place a number faster."
                    )
                }
                
                // Power-ups
                Section(header: Text("Power-ups")) {
                    RuleRow(
                        title: "×2 (Multiplier)",
                        description: "Doubles the value of the combo multiplier. Use it when you have a good combo for maximum points. The effect lasts until the next clear."
                    )
                    RuleRow(
                        title: "🎲 (Randomizer)",
                        description: "Randomly changes all numbers on the board. Use it when you're missing a small number for the target or when the board is close to overflowing."
                    )
                    RuleRow(
                        title: "→ (Clear Row)",
                        description: "Clears an entire row. Use it when a row is close to the target number or when you want to make space for new numbers."
                    )
                    RuleRow(
                        title: "↓ (Clear Column)",
                        description: "Clears an entire column. Use it when a column is close to the target number or when you want to make space for new numbers."
                    )
                }
                
                // Combo System
                Section(header: Text("Combo System")) {
                    RuleRow(
                        title: "Combo Multiplier",
                        description: "Each successful move increases the combo multiplier (maximum 5x). The combo resets if you don't clear any lines within 5 seconds."
                    )
                    RuleRow(
                        title: "Multiple Clears",
                        description: "Clear multiple rows or columns at once for a bigger combo and more points. Each additional line increases the combo multiplier."
                    )
                    RuleRow(
                        title: "Points",
                        description: "Points = number of cleared lines × 100 × combo multiplier. In Time Attack mode, points are multiplied by 1.5."
                    )
                }
                
                // Game Modes
                Section(header: Text("Game Modes")) {
                    RuleRow(
                        title: "Classic",
                        description: "Play until you lose. The target number increases with level. Every 500 points advances you to the next level. Falling speed increases with level."
                    )
                    RuleRow(
                        title: "Time Attack",
                        description: "Play against time. You get 50% more points. It's faster and more challenging. The game ends when time runs out."
                    )
                    RuleRow(
                        title: "Zen",
                        description: "Relaxing mode without time limit or game over. The target number remains constant. Perfect for practice and learning mechanics."
                    )
                }
                
                // Tips
                Section(header: Text("Tips")) {
                    RuleRow(
                        title: "Planning",
                        description: "Plan your moves ahead. Look at the next number and think about how you'll use it. Rotation is key for good planning."
                    )
                    RuleRow(
                        title: "Power-ups",
                        description: "Save power-ups for tough situations. ×2 is best for combos, and Randomizer for getting out of trouble. Clear Row/Column are great for making space."
                    )
                    RuleRow(
                        title: "Combo",
                        description: "Try to maintain your combo as long as possible. Clearing multiple lines at once is key for high scores. Remember the 5-second combo timeout."
                    )
                    RuleRow(
                        title: "Speed",
                        description: "The game gets faster with level. Use speed-up when needed, but be careful. Quick reactions are crucial for high scores."
                    )
                }
                
                // Game Over
                Section(header: Text("Game Over")) {
                    RuleRow(
                        title: "End Game",
                        description: "The game ends when a falling number cannot be stopped in any row. In Time Attack mode, the game also ends when time runs out."
                    )
                    RuleRow(
                        title: "Perfect Game",
                        description: "Complete the game without mistakes to get bonus points and achievements. A perfect game is counted when you make no mistakes and achieve a positive score."
                    )
                    RuleRow(
                        title: "High Score",
                        description: "Try to beat your high score. Each game is a new opportunity. Focus on maintaining combos and efficient use of power-ups."
                    )
                }
            }
            .navigationTitle("Game Rules")
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
}

struct RuleRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    GameRulesView()
} 