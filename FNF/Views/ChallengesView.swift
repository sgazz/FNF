import SwiftUI

struct ChallengesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var challengeManager = ChallengeManager.shared
    
    var body: some View {
        NavigationView {
            List {
                if challengeManager.dailyReward > 0 {
                    Section {
                        DailyRewardView(reward: challengeManager.dailyReward) {
                            challengeManager.claimDailyReward()
                        }
                        .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                Section(header: Text("Daily Challenges")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    ForEach(challengeManager.dailyChallenges) { challenge in
                        ChallengeRow(challenge: challenge)
                            .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                Section(header: Text("Active Challenges")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    ForEach(challengeManager.activeChallenges) { challenge in
                        ChallengeRow(challenge: challenge)
                            .listRowBackground(Color.black.opacity(0.3))
                    }
                }
                
                Section(header: Text("Completed Challenges")
                                .font(.headline)
                                .foregroundColor(.yellow)
                                .padding(.vertical, 5)
                    ) {
                    ForEach(challengeManager.challenges.filter { $0.isCompleted }) { challenge in
                        ChallengeRow(challenge: challenge)
                            .listRowBackground(Color.black.opacity(0.3))
                    }
                }
            }
            .navigationTitle("Challenges")
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

struct DailyRewardView: View {
    let reward: Int
    let onClaim: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "gift.fill")
                    .font(.title)
                    .foregroundColor(.yellow)
                Text("Daily Reward")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            
            Text("+\(reward) points")
                .font(.title2)
                .bold()
                .foregroundColor(.green)
            
            Button(action: onClaim) {
                Text("Claim")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                            )
                            .shadow(color: .yellow.opacity(0.6), radius: 8, x: 0, y: 0)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                )
                .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
        )
    }
}

struct ChallengeRow: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: challenge.type.icon)
                    .foregroundColor(challenge.isCompleted ? .green : .yellow)
                Text(challenge.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(challenge.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ProgressView(value: Double(max(0, min(challenge.progress, challenge.target))), total: Double(challenge.target))
                .tint(challenge.isCompleted ? .green : .yellow)
            
            HStack {
                Text("\(challenge.progress)/\(challenge.target)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("+\(challenge.reward) points")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            if let date = challenge.dateCompleted {
                Text("Completed: \(formatDate(date))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: challenge.isCompleted ? 2 : 1)
                )
                .shadow(color: .yellow.opacity(challenge.isCompleted ? 0.5 : 0.3), radius: challenge.isCompleted ? 8 : 5, x: 0, y: 0)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ChallengesView()
} 