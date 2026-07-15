import Foundation

/// Prepares a clean, populated app state for automated App Store screenshots.
///
/// This runs only when the app is launched with the `--uitest` argument (passed
/// by the fastlane `snapshot` UI test), so it never affects real users. Language,
/// theme, player name and the onboarding flag are supplied through the launch
/// argument domain (e.g. `-appLanguage de`); this type additionally seeds a set
/// of finished games so the History and Profile screens look populated.
enum UITestSupport {
    static var isActive: Bool {
        ProcessInfo.processInfo.arguments.contains("--uitest")
    }

    static func applyIfNeeded() {
        guard isActive else { return }
        let defaults = UserDefaults.standard

        // Skip onboarding and force a deterministic name + theme so the whole
        // screenshot set looks consistent across every device and language
        // (otherwise each simulator keeps whatever was last persisted in it).
        defaults.set(true, forKey: "hasCompletedOnboarding")
        defaults.set("Milan", forKey: "playerName")
        defaults.set("cherry", forKey: "appTheme")

        seedGameHistory(into: defaults)
    }

    /// Writes a handful of finished games so History and Profile aren't empty.
    /// Game-result strings are stored in their canonical German form (the app
    /// translates them for other locales via `L10n.translateResult`).
    private static func seedGameHistory(into defaults: UserDefaults) {
        // Keep in sync with `GameHistoryStore.storageKey`.
        let storageKey = "saved_games_v1"
        let day: TimeInterval = 86_400
        let now = Date()

        func game(daysAgo: Double,
                  color: String,
                  elo: Int,
                  result: String,
                  accuracy: Double,
                  challenge: Bool,
                  counts: [MoveClassification: Int]) -> SavedGame {
            SavedGame(date: now.addingTimeInterval(-daysAgo * day),
                      playerColor: color,
                      finalElo: elo,
                      gameResult: result,
                      accuracy: accuracy,
                      isChallenge: challenge,
                      counts: counts)
        }

        // A rising trajectory of Challenge games (drives the Profile trend charts)
        // plus a couple of normal games for variety in the History list.
        let games: [SavedGame] = [
            game(daysAgo: 1, color: "white", elo: 1620,
                 result: "Weiß gewinnt durch Schachmatt", accuracy: 91, challenge: true,
                 counts: [.brilliant: 1, .best: 14, .excellent: 6, .good: 5, .book: 4, .inaccuracy: 1]),
            game(daysAgo: 3, color: "black", elo: 1540,
                 result: "Schwarz gewinnt durch Schachmatt", accuracy: 86, challenge: true,
                 counts: [.best: 11, .excellent: 7, .good: 6, .book: 3, .inaccuracy: 2, .mistake: 1]),
            game(daysAgo: 6, color: "white", elo: 1470,
                 result: "Weiß gewinnt durch Schachmatt", accuracy: 88, challenge: true,
                 counts: [.great: 1, .best: 12, .excellent: 5, .good: 7, .book: 3, .inaccuracy: 1]),
            game(daysAgo: 9, color: "white", elo: 1385,
                 result: "Remis durch Zugwiederholung", accuracy: 79, challenge: true,
                 counts: [.best: 9, .excellent: 6, .good: 8, .book: 4, .inaccuracy: 3, .mistake: 1]),
            game(daysAgo: 12, color: "black", elo: 1440,
                 result: "Weiß gewinnt durch Schachmatt", accuracy: 74, challenge: false,
                 counts: [.best: 8, .excellent: 5, .good: 9, .book: 2, .inaccuracy: 3, .mistake: 2, .blunder: 1]),
            game(daysAgo: 16, color: "white", elo: 1310,
                 result: "Weiß gewinnt durch Schachmatt", accuracy: 81, challenge: false,
                 counts: [.best: 10, .excellent: 4, .good: 6, .book: 3, .inaccuracy: 2, .mistake: 1]),
        ]

        if let data = try? JSONEncoder().encode(games) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
