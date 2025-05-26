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
        .background(Color.black.opacity(0.3))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
        )
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
        VStack(spacing: 2) {
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
        HStack(spacing: 2) {
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
                    .fill(Color.purple.opacity(0.7))
                    .shadow(color: .purple.opacity(0.5), radius: 10)
            )
            .scaleEffect(1.2)
    }
}

#Preview {
    GameBoardView(gameState: GameState())
} 