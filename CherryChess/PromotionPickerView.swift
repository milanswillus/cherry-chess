import SwiftUI
import ChessKit

/// Shared modal overlay for choosing a pawn-promotion piece.
/// Used by the game/analysis tabs and the mate trainer.
struct PromotionPickerView: View {
    @AppStorage("appLanguage") private var appLanguage = "de"
    @AppStorage("appTheme") private var appTheme = "cherry"
    let promotingColor: Piece.Color
    let onSelect: (Piece.Kind) -> Void

    var body: some View {
        let _ = appLanguage
        let _ = appTheme
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(appLanguage == "de" ? "Bauernumwandlung" : "Pawn Promotion")
                    .font(.system(.headline, design: .rounded).bold())
                    .foregroundColor(Theme.textMain)
                    .tracking(1.0)

                HStack(spacing: 16) {
                    let colorPrefix = promotingColor == .white ? "w" : "b"
                    let options: [(Piece.Kind, String)] = [
                        (.queen, "q"),
                        (.rook, "r"),
                        (.bishop, "b"),
                        (.knight, "n")
                    ]

                    ForEach(options, id: \.0) { kind, suffix in
                        Button(action: {
                            withAnimation {
                                onSelect(kind)
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(colorPrefix + suffix)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                    .padding(10)
                                    .background(Theme.panelBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Theme.line.opacity(0.1), lineWidth: 1)
                                    )

                                Text(pieceKindName(kind))
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 28)
            .background(Theme.panelBackground)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Theme.line.opacity(0.08), lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
    }

    private func pieceKindName(_ kind: Piece.Kind) -> String {
        switch kind {
        case .queen:
            return appLanguage == "de" ? "Dame" : "Queen"
        case .rook:
            return appLanguage == "de" ? "Turm" : "Rook"
        case .bishop:
            return appLanguage == "de" ? "Läufer" : "Bishop"
        case .knight:
            return appLanguage == "de" ? "Springer" : "Knight"
        default:
            return ""
        }
    }
}
