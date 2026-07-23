# High Power Football iOS App

This folder is a separate Capacitor iOS wrapper for HPF.

The iOS app loads the live football game:

`https://paschallgamehub.cloud/football/index.html`

## Local Setup

```bash
npm install
npm run ios:init
npm run ios:sync
npm run ios:open
```

Open the generated Xcode project at:

`ios/App/App.xcodeproj`

## App Store Setup

- Set Apple signing team in Xcode.
- Confirm bundle ID: `com.paschallgamehub.highpowerfootball`.
- Add app icon assets.
- Configure launch screen.
- Set deployment target.
- Test on a real iPhone.
- Archive and upload to App Store Connect.
- Test through TestFlight before App Store submission.

## Future Web Updates

Because this wrapper loads the live HPF URL, normal HPF web updates do not need to be copied into this folder. Deploy the web version as usual; the iOS app will load the updated live site.
