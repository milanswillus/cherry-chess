import SwiftUI

struct Theme {
    enum ThemeType: String, CaseIterable, Identifiable {
        case standard = "standard"
        case darkNeon = "darkNeon"
        case midnightGold = "midnightGold"
        case sweetRose = "sweetRose"
        
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .standard: return L10n.tr("standard")
            case .darkNeon: return L10n.tr("dark_neon")
            case .midnightGold: return L10n.tr("midnight_gold")
            case .sweetRose: return L10n.tr("sweet_rose")
            }
        }
    }
    
    static var current: ThemeType {
        let saved = UserDefaults.standard.string(forKey: "appTheme") ?? "standard"
        return ThemeType(rawValue: saved) ?? .standard
    }
    
    static var darkSquare: Color {
        switch current {
        case .standard:
            return Color(red: 119/255, green: 149/255, blue: 86/255) // #779556
        case .darkNeon:
            return Color(red: 24/255, green: 30/255, blue: 46/255) // #181E2E
        case .midnightGold:
            return Color(red: 77/255, green: 58/255, blue: 47/255) // #4D3A2F
        case .sweetRose:
            return Color(red: 196/255, green: 115/255, blue: 140/255) // #C4738C
        }
    }
    
    static var lightSquare: Color {
        switch current {
        case .standard:
            return Color(red: 235/255, green: 236/255, blue: 208/255) // #ebecd0
        case .darkNeon:
            return Color(red: 45/255, green: 55/255, blue: 80/255) // #2D3750
        case .midnightGold:
            return Color(red: 205/255, green: 186/255, blue: 150/255) // #CDBA96
        case .sweetRose:
            return Color(red: 251/255, green: 228/255, blue: 236/255) // #FBE4EC
        }
    }
    
    static func lightSquareForPreview(_ type: ThemeType) -> Color {
        switch type {
        case .standard:
            return Color(red: 235/255, green: 236/255, blue: 208/255)
        case .darkNeon:
            return Color(red: 45/255, green: 55/255, blue: 80/255)
        case .midnightGold:
            return Color(red: 205/255, green: 186/255, blue: 150/255)
        case .sweetRose:
            return Color(red: 251/255, green: 228/255, blue: 236/255)
        }
    }
    
    static func darkSquareForPreview(_ type: ThemeType) -> Color {
        switch type {
        case .standard:
            return Color(red: 119/255, green: 149/255, blue: 86/255)
        case .darkNeon:
            return Color(red: 24/255, green: 30/255, blue: 46/255)
        case .midnightGold:
            return Color(red: 77/255, green: 58/255, blue: 47/255)
        case .sweetRose:
            return Color(red: 196/255, green: 115/255, blue: 140/255)
        }
    }
    
    static var highlightSquare: Color {
        switch current {
        case .standard:
            return Color(red: 245/255, green: 246/255, blue: 130/255).opacity(0.8) // #f5f682
        case .darkNeon:
            return Color(red: 255/255, green: 0/255, blue: 128/255).opacity(0.65) // Neon Magenta/Pink selection
        case .midnightGold:
            return Color(red: 212/255, green: 175/255, blue: 55/255).opacity(0.65) // Soft Amber/Gold selection
        case .sweetRose:
            return Color(red: 255/255, green: 92/255, blue: 138/255).opacity(0.65) // Hot pink selection
        }
    }
    
    static var lastMoveHighlight: Color {
        switch current {
        case .standard:
            return Color(red: 245/255, green: 246/255, blue: 130/255).opacity(0.4) // Subtle standard yellow
        case .darkNeon:
            return Color(red: 0/255, green: 255/255, blue: 200/255).opacity(0.25) // Neon Cyan last move highlight
        case .midnightGold:
            return Color(red: 255/255, green: 179/255, blue: 0/255).opacity(0.25) // Warm Gold last move highlight
        case .sweetRose:
            return Color(red: 255/255, green: 133/255, blue: 162/255).opacity(0.3) // Soft rose last move highlight
        }
    }
    
    static var background: Color {
        switch current {
        case .standard:
            return Color(red: 48/255, green: 46/255, blue: 43/255) // #302E2B
        case .darkNeon:
            return Color(red: 11/255, green: 13/255, blue: 24/255) // #0B0D18
        case .midnightGold:
            return Color(red: 13/255, green: 13/255, blue: 17/255) // #0D0D11
        case .sweetRose:
            return Color(red: 31/255, green: 17/255, blue: 22/255) // #1F1116
        }
    }
    
    static var panelBackground: Color {
        switch current {
        case .standard:
            return Color(red: 38/255, green: 37/255, blue: 34/255) // #262522
        case .darkNeon:
            return Color(red: 18/255, green: 22/255, blue: 36/255) // #121624
        case .midnightGold:
            return Color(red: 24/255, green: 24/255, blue: 32/255) // #181820
        case .sweetRose:
            return Color(red: 45/255, green: 25/255, blue: 33/255) // #2D1921
        }
    }
    
    static var textMain: Color {
        return Color.white
    }
    
    static var textSecondary: Color {
        switch current {
        case .standard:
            return Color(white: 0.6)
        case .darkNeon:
            return Color(red: 148/255, green: 163/255, blue: 184/255) // Slate 400
        case .midnightGold:
            return Color(red: 168/255, green: 158/255, blue: 140/255) // Slate-Sand
        case .sweetRose:
            return Color(red: 212/255, green: 168/255, blue: 182/255) // Dusty rose-gray
        }
    }
    
    // Dynamic Accent Colors (e.g. for buttons, sliders, active states)
    static var accentColor: Color {
        switch current {
        case .standard:
            return Color(red: 119/255, green: 149/255, blue: 86/255) // Standard green
        case .darkNeon:
            return Color(red: 255/255, green: 0/255, blue: 128/255) // Neon Magenta #FF0080
        case .midnightGold:
            return Color(red: 212/255, green: 175/255, blue: 55/255) // Burnished Gold #D4AF37
        case .sweetRose:
            return Color(red: 255/255, green: 82/255, blue: 123/255) // Sweet Pink #FF527B
        }
    }
    
    // Theme-based result outcomes (Win/Loss)
    static var winColor: Color {
        switch current {
        case .standard:
            return Color(red: 129/255, green: 182/255, blue: 76/255) // Green
        case .darkNeon:
            return Color(red: 0/255, green: 255/255, blue: 200/255) // Cyan
        case .midnightGold:
            return Color(red: 212/255, green: 175/255, blue: 55/255) // Gold
        case .sweetRose:
            return Color(red: 107/255, green: 224/255, blue: 163/255) // Minty Green
        }
    }
    
    static var lossColor: Color {
        switch current {
        case .standard:
            return Color(red: 225/255, green: 61/255, blue: 61/255) // Red
        case .darkNeon:
            return Color(red: 255/255, green: 0/255, blue: 128/255) // Neon Magenta
        case .midnightGold:
            return Color(red: 192/255, green: 57/255, blue: 43/255) // Soft Crimson
        case .sweetRose:
            return Color(red: 255/255, green: 75/255, blue: 114/255) // Hot Crimson/Cherry
        }
    }
    
    // Board premove highlight color
    static var premoveColor: Color {
        switch current {
        case .standard:
            return Color.red.opacity(0.25)
        case .darkNeon:
            return Color(red: 255/255, green: 0/255, blue: 128/255).opacity(0.25) // Neon Magenta
        case .midnightGold:
            return Color(red: 230/255, green: 81/255, blue: 0/255).opacity(0.25) // Burnt Orange
        case .sweetRose:
            return Color(red: 255/255, green: 102/255, blue: 178/255).opacity(0.3) // Bubblegum Pink
        }
    }
    
    // Board hint highlight color
    static var hintColor: Color {
        switch current {
        case .standard:
            return Color.blue.opacity(0.55)
        case .darkNeon:
            return Color(red: 0/255, green: 255/255, blue: 200/255).opacity(0.6) // Glowing Neon Cyan
        case .midnightGold:
            return Color(red: 255/255, green: 179/255, blue: 0/255).opacity(0.6) // Glowing Warm Amber/Gold
        case .sweetRose:
            return Color(red: 214/255, green: 162/255, blue: 232/255).opacity(0.65) // Glowing Sweet Lavender
        }
    }
    
    // Modern gradients for UI accents
    static var primaryGradient: LinearGradient {
        switch current {
        case .standard:
            return LinearGradient(
                colors: [Color(red: 119/255, green: 149/255, blue: 86/255), Color(red: 95/255, green: 120/255, blue: 68/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .darkNeon:
            return LinearGradient(
                colors: [Color(red: 255/255, green: 0/255, blue: 128/255), Color(red: 139/255, green: 92/255, blue: 246/255)], // Neon Pink to Violet
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .midnightGold:
            return LinearGradient(
                colors: [Color(red: 212/255, green: 175/255, blue: 55/255), Color(red: 186/255, green: 104/255, blue: 30/255)], // Gold to Copper-red
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sweetRose:
            return LinearGradient(
                colors: [Color(red: 255/255, green: 107/255, blue: 139/255), Color(red: 255/255, green: 164/255, blue: 182/255)], // Rose pink to sweet peach
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct ClassificationColor {
    static let brilliant = Color(red: 27/255, green: 172/255, blue: 166/255) // Teal
    static let great = Color(red: 92/255, green: 139/255, blue: 181/255) // Blue
    static let best = Color(red: 163/255, green: 206/255, blue: 39/255) // Green
    static let excellent = Color(red: 155/255, green: 199/255, blue: 0/255) // Light Green
    static let good = Color(red: 150/255, green: 175/255, blue: 139/255) // Grayish green
    static let inaccuracy = Color(red: 240/255, green: 193/255, blue: 92/255) // Yellow
    static let mistake = Color(red: 230/255, green: 145/255, blue: 44/255) // Orange
    static let blunder = Color(red: 202/255, green: 52/255, blue: 49/255) // Red
    static let missed = Color(red: 255/255, green: 119/255, blue: 105/255) // Pink/Red
    static let forced = Color(red: 140/255, green: 150/255, blue: 160/255) // Gray
    static let book = Color(red: 168/255, green: 136/255, blue: 101/255) // Brown
}

extension Font {
    static func roundedSystem(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        return Font.system(style, design: .rounded).weight(weight)
    }
    static func roundedSystem(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .rounded)
    }
}
