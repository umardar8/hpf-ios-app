# HPF iOS Wrapper Context

## What This Project Is

This folder is the future standalone iOS app wrapper for **High Power Football (HPF)**.

HPF itself is a vanilla JavaScript, audio-first American football game for blind and visually impaired players. The web version lives in the main `high-power-football` project under:

`public/football`

This iOS wrapper should be maintained as a separate repo from the web/VPS repo.

## Current Strategy

The iOS app uses Capacitor and loads the live HPF web game:

`https://paschallgamehub.cloud/football/index.html`

That means:

- The deployed web version remains the source of truth for HPF gameplay.
- Most football gameplay changes should be made in the web repo, not inside this iOS wrapper.
- The iOS app automatically receives web gameplay updates after the website is deployed.
- This wrapper only needs app-store/native changes such as icons, splash screen, bundle ID, signing, native permissions, or Capacitor config.

## Do Not Manually Edit

After Capacitor generates the native iOS project, it will copy web assets into:

`ios/App/App/public`

Do not manually edit those copied files. They are generated/synced by Capacitor.

Because this app loads the live URL, copied local web assets are fallback/scaffold files, not the main HPF code path.

## Setup Commands

Run these from this folder on a Mac with Xcode installed:

```bash
npm install
npm run ios:init
npm run ios:sync
npm run ios:open
```

The Xcode project will be:

`ios/App/App.xcodeproj`

## Current App Identity

- App name: `High Power Football`
- Bundle ID: `com.paschallgamehub.highpowerfootball`
- Live URL: `https://paschallgamehub.cloud/football/index.html`

## Xcode Tasks

In Xcode:

- Set the Apple Developer signing team.
- Confirm or adjust the bundle identifier.
- Add app icons.
- Configure launch screen/splash screen.
- Set deployment target.
- Test on a real iPhone.
- Archive and upload to App Store Connect.
- Test through TestFlight.

## Apple Review Notes

HPF is an audio-first accessible game, not a passive website. App Store metadata should emphasize:

- Blind and low-vision accessibility.
- Built-in narrator/audio-first gameplay.
- Regular Game, Tournament Mode, Season Mode, Load Saved Game, Settings, How To Play, Edit Player Name, Leaderboards, and Credits.
- Touch/mobile support.
- Save/load and online features where stable.

Important: if premium digital gameplay is sold or unlocked inside the iOS app, Apple may require Apple In-App Purchase. Avoid adding or promoting external payment flows inside the iOS app until the monetization path is reviewed.

## Future Native/Bundled Version

A future version can bundle HPF locally instead of loading the live URL. Before doing that, the web game must be refactored so relative server calls such as:

- `/api/...`
- `/socket.io/socket.io.js`

use an explicit production API base URL. Otherwise a bundled WebView will look for those routes inside the local app instead of the server.

## Standing Development Preference

Do not change HPF gameplay/UI from this wrapper repo unless explicitly asked. Gameplay changes belong in the web HPF repo first.
