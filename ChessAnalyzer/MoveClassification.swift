import SwiftUI

enum MoveClassification: String {
    case brilliant = "Brillant"
    case great = "Großartiger Zug"
    case best = "Bester Zug"
    case excellent = "Exzellent"
    case good = "Gut"
    case inaccuracy = "Ungenauigkeit"
    case mistake = "Fehler"
    case blunder = "Grober Fehler"
    case missed = "Verpasst"
    case forced = "Forciert"
    case book = "Buch"
    case none = "Keine"
    
    var displayName: String {
        switch self {
        case .brilliant: return L10n.tr("brilliant")
        case .great: return L10n.tr("great")
        case .best: return L10n.tr("best")
        case .excellent: return L10n.tr("excellent")
        case .good: return L10n.tr("good")
        case .inaccuracy: return L10n.tr("inaccuracy")
        case .mistake: return L10n.tr("mistake")
        case .blunder: return L10n.tr("blunder")
        case .missed: return L10n.tr("missed")
        case .forced: return L10n.tr("forced")
        case .book: return L10n.tr("book")
        case .none: return L10n.tr("none")
        }
    }
    
    var color: Color {
        switch self {
        case .brilliant: return ClassificationColor.brilliant
        case .great: return ClassificationColor.great
        case .best: return ClassificationColor.best
        case .excellent: return ClassificationColor.excellent
        case .good: return ClassificationColor.good
        case .inaccuracy: return ClassificationColor.inaccuracy
        case .mistake: return ClassificationColor.mistake
        case .blunder: return ClassificationColor.blunder
        case .missed: return ClassificationColor.missed
        case .forced: return ClassificationColor.forced
        case .book: return ClassificationColor.book
        case .none: return .clear
        }
    }
    
    var symbol: String {
        switch self {
        case .brilliant: return "!!"
        case .great: return "!"
        case .best: return "★"
        case .excellent: return "👍"
        case .good: return "✓"
        case .inaccuracy: return "?!"
        case .mistake: return "?"
        case .blunder: return "??"
        case .missed: return "X"
        case .forced: return "⚑"
        case .book: return "📖"
        case .none: return ""
        }
    }
    
    var iconName: String? {
        switch self {
        case .excellent: return "hand.thumbsup.fill"
        case .book: return "book.fill"
        case .missed: return "xmark"
        default: return nil
        }
    }
}

struct MoveClassificationBadge: View {
    let classification: MoveClassification
    var size: CGFloat = 24
    
    var body: some View {
        if classification != .none {
            ZStack {
                Circle()
                    .fill(classification.color)
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.18), radius: 2.5, x: 0, y: 1.2)
                
                if let icon = classification.iconName {
                    Image(systemName: icon)
                        .font(.system(size: size * 0.55))
                        .foregroundColor(.white)
                } else {
                    Text(classification.symbol)
                        .font(.system(size: size * 0.6))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct CheckmateBadge: View {
    var size: CGFloat = 24
    
    var body: some View {
        ZStack {
            Circle()
                .fill(ClassificationColor.blunder)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.18), radius: 2.5, x: 0, y: 1.2)
            
            Text("#")
                .font(.system(size: size * 0.6, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct DrawBadge: View {
    var size: CGFloat = 24
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.18), radius: 2.5, x: 0, y: 1.2)
            
            Text("½")
                .font(.system(size: size * 0.6, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
