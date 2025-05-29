import SwiftUI

struct GameBoardView: View {
    @ObservedObject var gameState: GameState
    @State private var isFastFalling = false
    @State private var showPowerUpEffect = false
    @State private var powerUpType: PowerUpType?
    
    var body: some View {
        GameBoardContent(
            gameState: gameState,
            isFastFalling: $isFastFalling,
            showPowerUpEffect: $showPowerUpEffect,
            powerUpType: $powerUpType
        )
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
        )
        .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: gameState.board)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: gameState.fallingPosition)
        .onChange(of: gameState.lastPowerUp) { _, newPowerUp in
            if let powerUp = newPowerUp {
                powerUpType = powerUp
                withAnimation {
                    showPowerUpEffect = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showPowerUpEffect = false
                    }
                }
            }
        }
    }
}

private struct GameBoardContent: View {
    @ObservedObject var gameState: GameState
    @Binding var isFastFalling: Bool
    @Binding var showPowerUpEffect: Bool
    @Binding var powerUpType: PowerUpType?
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<GameState.rows, id: \.self) { row in
                GameBoardRow(
                    row: row,
                    gameState: gameState
                )
            }
        }
        .overlay(
            Group {
                if showPowerUpEffect, let powerUp = powerUpType {
                    PowerUpEffectView(powerUp: powerUp)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    handleDragGesture(gesture)
                }
                .onEnded { _ in
                    isFastFalling = false
                }
        )
    }
    
    private func handleDragGesture(_ gesture: DragGesture.Value) {
        let threshold: CGFloat = 50
        
        if gesture.translation.width > threshold {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                gameState.moveRight()
            }
        } else if gesture.translation.width < -threshold {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                gameState.moveLeft()
            }
        }
        
        if gesture.translation.height > threshold {
            isFastFalling = true
        }
    }
}

private struct GameBoardRow: View {
    let row: Int
    @ObservedObject var gameState: GameState
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<GameState.columns, id: \.self) { column in
                CellView(value: getCellValue(row: row, column: column))
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func getCellValue(row: Int, column: Int) -> Int {
        if row == gameState.fallingPosition.row && column == gameState.fallingPosition.column {
            return gameState.fallingNumber
        }
        return gameState.board[row][column]
    }
}

struct PowerUpEffectView: View {
    let powerUp: PowerUpType
    
    var body: some View {
        Text(powerUp.symbol)
            .font(.system(size: 50))
            .bold()
            .foregroundColor(.white)
            .padding()
            .background(
                Circle()
                    .fill(Color.black.opacity(0.7))
                    .shadow(color: .yellow.opacity(0.8), radius: 15)
            )
            .scaleEffect(1.2)
    }
}

#Preview {
    GameBoardView(gameState: GameState())
} 