import SwiftUI

struct GameRulesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Introduction
                Section(header: Text("Introduction")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Welcome to Fall Number...Fall!",
                        description: "A fast-paced puzzle game where you combine falling numbers to reach target sums. Think fast, plan ahead, and master the art of number placement!"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Beginner's Guide
                Section(header: Text("Beginner's Guide")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Getting Started",
                        description: "Start with Zen mode to learn the basics. Focus on making simple combinations first. Remember: you can always rotate numbers to plan your next move."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "First Steps",
                        description: "1. Watch the next number\n2. Plan where to place it\n3. Use rotation to get better numbers\n4. Try to clear rows or columns\n5. Don't rush - speed comes with practice"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Visual Examples",
                        description: "• Good: 3 + 4 + 3 = 10 (target)\n• Better: 3 + 4 + 3 + 5 = 15 (combo!)\n• Best: Clear multiple lines at once!"
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Basic Rules
                Section(header: Text("Basic Rules")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Game Board",
                        description: "The game takes place on a board with 10 rows and 6 columns. Each cell can contain a number from 1-9, a power-up, or be empty. Numbers fall from the top of the board and must be placed in empty cells."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Game Objective",
                        description: "Achieve the target number in a row or column to score points. The target number increases with level (starts at 9 and can reach up to 20), except in Zen mode where it remains constant. Every 500 points advances you to the next level."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Falling Numbers",
                        description: "Numbers fall from the top of the board. You can see the next number that will fall. The chance for a power-up is 10%. Numbers range from 1 to 9."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Controls
                Section(header: Text("Controls")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Movement",
                        description: "Use arrow keys to move numbers left and right within a column. Numbers can only be moved while falling."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Rotation",
                        description: "Use the rotation button to swap the current falling number with the next number in queue. This is a key mechanic for planning moves and getting better combinations."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Speed Up",
                        description: "Hold the speed button to accelerate the falling number. The falling speed increases 5 times. Use this when you want to place a number faster."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Power-ups
                Section(header: Text("Power-ups")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Power-up Basics",
                        description: "Power-ups are available in all game modes. In Zen mode, they can be used without time or score restrictions, but still depend on the 10% drop chance. Each power-up has a specific effect and strategic use."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "×2 (Multiplier)",
                        description: "Doubles the value of the combo multiplier. Use it when you have a good combo for maximum points. The effect lasts until the next clear."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "🎲 (Randomizer)",
                        description: "Randomly changes all numbers on the board. Use it when you're missing a small number for the target or when the board is close to overflowing."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "→ (Clear Row)",
                        description: "Clears an entire row. Use it when a row is close to the target number or when you want to make space for new numbers."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "↓ (Clear Column)",
                        description: "Clears an entire column. Use it when a column is close to the target number or when you want to make space for new numbers."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Combo System
                Section(header: Text("Combo System")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Combo Multiplier",
                        description: "Each successful move increases the combo multiplier (maximum 5x). The combo resets if you don't clear any lines within 5 seconds. This timer applies to all modes, including Time Attack - the faster pace requires even more careful planning."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Multiple Clears",
                        description: "Clear multiple rows or columns at once for a bigger combo and more points. Each additional line increases the combo multiplier."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Points",
                        description: "Points = number of cleared lines × 100 × combo multiplier. In Time Attack mode, points are multiplied by 1.5."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Game Modes
                Section(header: Text("Game Modes")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Classic",
                        description: "Play until you lose. The target number increases with level. Every 500 points advances you to the next level. Falling speed increases with level."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Time Attack",
                        description: "Play against time. You get 50% more points. It's faster and more challenging. The game ends when time runs out."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Zen",
                        description: "Relaxing mode without time limit or game over. The target number remains constant. Perfect for practice and learning mechanics."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Challenges",
                        description: "Complete daily and weekly challenges to earn rewards. Each challenge has specific objectives and time limits. Perfect for testing your skills and earning bonus points."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Survival",
                        description: "Test your endurance in this challenging mode. The game gets progressively harder with each level. Survive as long as possible and compete for the highest score."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Challenges & Rewards
                Section(header: Text("Challenges & Rewards")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Daily Challenges",
                        description: "New challenges every day. Complete them to earn bonus points and special rewards. Challenges reset at midnight."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Weekly Challenges",
                        description: "More difficult challenges that last for a week. These offer bigger rewards and test your mastery of the game."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Rewards",
                        description: "Earn points, power-ups, and special items by completing challenges. Use these rewards to enhance your gameplay and achieve higher scores."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Progress System
                Section(header: Text("Progress System")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Levels",
                        description: "Gain experience points by playing games and completing challenges. Each level unlocks new features and increases your maximum combo multiplier."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Achievements",
                        description: "Complete special objectives to earn achievements. These showcase your skills and provide additional rewards."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Leaderboards",
                        description: "Compete with other players for the highest scores in each game mode. Daily, weekly, and all-time leaderboards available."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Points System
                Section(header: Text("Points System")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Basic Points",
                        description: "Points = number of cleared lines × 100 × combo multiplier. In Time Attack mode, points are multiplied by 1.5."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Challenge Points",
                        description: "Complete challenges to earn bonus points. Daily challenges offer 100-500 points, while weekly challenges can reward up to 2000 points."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Achievement Points",
                        description: "Earn points by unlocking achievements. These points contribute to your overall progress and level advancement."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Tips
                Section(header: Text("Tips")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "Planning",
                        description: "Plan your moves ahead. Look at the next number and think about how you'll use it. Rotation is key for good planning."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Power-ups",
                        description: "Save power-ups for tough situations. ×2 is best for combos, and Randomizer for getting out of trouble. Clear Row/Column are great for making space."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Combo",
                        description: "Try to maintain your combo as long as possible. Clearing multiple lines at once is key for high scores. Remember the 5-second combo timeout."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Speed",
                        description: "The game gets faster with level. Use speed-up when needed, but be careful. Quick reactions are crucial for high scores."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
                
                // Game Over
                Section(header: Text("Game Over")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    RuleRow(
                        title: "End Game",
                        description: "The game ends when a falling number cannot be stopped in any row. In Time Attack mode, the game also ends when time runs out. This does not apply to Zen mode, which has no game over - you can play indefinitely."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "Perfect Game",
                        description: "Complete the game without mistakes to get bonus points and achievements. A perfect game is counted when you make no mistakes and achieve a positive score."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                    RuleRow(
                        title: "High Score",
                        description: "Try to beat your high score. Each game is a new opportunity. Focus on maintaining combos and efficient use of power-ups."
                    )
                    .listRowBackground(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("Game Rules")
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
}

struct RuleRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: .yellow.opacity(0.3), radius: 5, x: 0, y: 0)
        )
    }
}

#Preview {
    VStack {
        GameRulesView()
        
        Divider()
            .background(Color.gray)
            .padding()
        
        RuleRow(
            title: "Test Rule",
            description: "This is a test rule description that shows how the rule row looks."
        )
        .padding()
    }
    .background(Color.black)
} 
