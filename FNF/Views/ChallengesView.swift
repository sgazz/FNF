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
                    }
                }
                
                Section(header: Text("Daily Challenges")) {
                    ForEach(challengeManager.dailyChallenges) { challenge in
                        ChallengeRow(challenge: challenge)
                    }
                }
                
                Section(header: Text("Active Challenges")) {
                    ForEach(challengeManager.activeChallenges) { challenge in
                        ChallengeRow(challenge: challenge)
                    }
                }
                
                Section(header: Text("Completed Challenges")) {
                    ForEach(challengeManager.challenges.filter { $0.isCompleted }) { challenge in
                        ChallengeRow(challenge: challenge)
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
                }
            }
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
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue.opacity(0.1))
        )
    }
}

struct ChallengeRow: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: challenge.type.icon)
                    .foregroundColor(challenge.isCompleted ? .green : .blue)
                Text(challenge.title)
                    .font(.headline)
                Spacer()
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Text(challenge.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: Double(challenge.progress), total: Double(challenge.target))
                .tint(challenge.isCompleted ? .green : .blue)
            
            HStack {
                Text("\(challenge.progress)/\(challenge.target)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("+\(challenge.reward) points")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            if let date = challenge.dateCompleted {
                Text("Completed: \(formatDate(date))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
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