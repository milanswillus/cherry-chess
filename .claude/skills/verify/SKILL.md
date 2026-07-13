---
name: verify
description: Build CherryChess for iOS to verify changes compile; the user runs UI testing.
---

# Verify CherryChess

The app was renamed from ChessCompanion to **Cherry Chess** (target/project
`CherryChess`, bundle id `com.CherryChess`, display name "Cherry Chess"). The
repo lives at `/Users/milanswillus/dev/CherryChess`.

## Build (primary verification)

`xcodebuild` needs the full Xcode (CLT alone fails with "requires Xcode"):

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project CherryChess.xcodeproj -scheme CherryChess \
  -destination 'generic/platform=iOS Simulator' build
```

A green `** BUILD SUCCEEDED **` is the expected verification for code changes.
**Do not drive the simulator UI to test** — the user does visual/interactive
testing themselves (see the `no-self-ui-testing` memory). Reserve simulator runs
for non-interactive checks (e.g. reading logs, static screenshots without
navigation).

## Install & launch (only if explicitly needed)

Deployment target is iOS 26.x — iOS 18 simulators refuse the install. Use an
iOS 26.x device (e.g. iPhone 17 Pro):

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
UDID=$(xcrun simctl list devices available | grep -A3 "iOS 26" | grep "iPhone 17 Pro (" | grep -oE '[A-F0-9-]{36}' | head -1)
xcrun simctl boot $UDID; xcrun simctl bootstatus $UDID -b
APP=$(ls -d ~/Library/Developer/Xcode/DerivedData/CherryChess-*/Build/Products/Debug-iphonesimulator/CherryChess.app | head -1)
xcrun simctl install $UDID "$APP"
xcrun simctl launch $UDID com.CherryChess
```

`@AppStorage` keys can be forced per-launch via launch args (NSArgumentDomain
beats stored defaults), e.g.:

```bash
xcrun simctl launch $UDID com.CherryChess -appTheme cherry -hasCompletedOnboarding NO
```

Theme keys: `cherry` (default), `standard`, `darkNeon`, `midnightGold`,
`sweetRose`, `onyx`, `aquamarine`. Other keys: `hasCompletedOnboarding`,
`appLanguage` (de|en), `showBoardCoordinates`.

## Gotchas

- Always `simctl terminate $UDID com.CherryChess` before relaunching, or a stale
  process's UI shows in screenshots.
- Engine regression signal: the repo dir must stay free of `engine_log.txt`,
  `game_flow_log.txt`, `test_result.txt` after running the app (dev-logging was
  removed pre-App-Store; those writers had used hardcoded repo paths).
