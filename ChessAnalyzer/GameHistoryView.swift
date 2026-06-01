import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var store = GameHistoryStore.shared
    @AppStorage("appLanguage") private var appLanguage = "de"
    @AppStorage("appTheme") private var appTheme = "standard"
    
    private let displayOrder: [MoveClassification] = [
        .brilliant, .great, .best, .excellent, .good, .book, .inaccuracy, .mistake, .blunder
    ]
    
    var body: some View {
        let _ = appLanguage
        let _ = appTheme
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(L10n.tr("game_history"))
                        .font(.system(.title2, design: .rounded).bold())
                        .foregroundColor(Theme.textMain)
                    
                    Spacer()
                    
                    if !store.games.isEmpty {
                        Button(action: {
                            store.clearAll()
                            HapticManager.shared.playNotification(.warning)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "trash")
                                Text(L10n.tr("clear_history"))
                            }
                            .font(.system(.caption, design: .rounded).bold())
                            .foregroundColor(Theme.lossColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Theme.lossColor.opacity(0.15))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.lossColor.opacity(0.25), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding()
                
                if store.games.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.textSecondary.opacity(0.5))
                        Text(L10n.tr("no_saved_games"))
                            .font(.system(.title3, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Text(L10n.tr("complete_game_to_view"))
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(Theme.textSecondary.opacity(0.6))
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(store.games) { game in
                            GameRowView(game: game, displayOrder: displayOrder)
                                .listRowBackground(Theme.panelBackground)
                                .listRowSeparatorTint(Color.white.opacity(0.06))
                        }
                        .onDelete { indices in
                            store.delete(at: indices)
                            HapticManager.shared.playImpact(.medium)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}

struct GameRowView: View {
    @AppStorage("appLanguage") private var appLanguage = "de"
    @AppStorage("appTheme") private var appTheme = "standard"
    let game: SavedGame
    let displayOrder: [MoveClassification]
    @ObservedObject var store = GameHistoryStore.shared
    
    private var colorCircle: some View {
        Circle()
            .fill(game.playerColor == "white" ? Color.white : Color.black)
            .frame(width: 14, height: 14)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: game.playerColor == "black" ? 1 : 0)
            )
    }
    
    private var resultColor: Color {
        if game.gameResult.contains("Schachmatt") {
            return game.gameResult.contains("Weiß") && game.playerColor == "white" ? Theme.winColor :
                   game.gameResult.contains("Schwarz") && game.playerColor == "black" ? Theme.winColor : Theme.lossColor
        }
        return .gray
    }
    
    var body: some View {
        let _ = appLanguage
        let _ = appTheme
        VStack(alignment: .leading, spacing: 8) {
            // Top row: date + color + result
            HStack(spacing: 12) {
                colorCircle
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.translateResult(game.gameResult))
                        .font(.system(.subheadline, design: .rounded).bold())
                        .foregroundColor(resultColor)
                    Text(game.date, style: .date)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                // Final Elo
                VStack(alignment: .trailing, spacing: 2) {
                    Text(L10n.tr("final_elo"))
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                    Text("\(game.finalElo)")
                        .font(.system(.headline, design: .rounded).bold())
                        .foregroundColor(Theme.accentColor)
                }
                
                Button(action: {
                    store.delete(game: game)
                }) {
                    Image(systemName: "trash")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(Theme.lossColor.opacity(0.8))
                        .padding(6)
                        .background(Theme.lossColor.opacity(0.12))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Classification badges
            let counts = game.countsDict
            let nonZero = displayOrder.filter { (counts[$0] ?? 0) > 0 }
            if !nonZero.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(nonZero, id: \.self) { cls in
                            HStack(spacing: 3) {
                                MoveClassificationBadge(classification: cls, size: 14)
                                Text("\(counts[cls]!)")
                                    .font(.system(.caption2, design: .rounded).monospacedDigit().bold())
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
