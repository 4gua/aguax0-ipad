# AguaX0 Car App

AguaX0 is an in-car companion prototype designed for iPad mini 6.

This repo currently includes two connected parts:

- A React/Vite prototype in `src/App.jsx`
- An iOS wrapper project in `ios/AguaX0iPad.xcodeproj` that loads the React prototype inside `WKWebView`

## Current Product Direction

- Preserve the approved React design while iterating quickly
- Use the iOS shell for simulator/device testing on iPad
- Move toward a real iPad app that can later use native features like GPS, maps, microphone, and local storage

## Project Structure

- `src/`: React UI source
- `public/`: web assets
- `ios/AguaX0iPad/`: iOS app source
- `ios/AguaX0iPad/Prototype/`: bundled React build used as the native fallback

## Run The Web Prototype

```bash
npm install
npm run dev
```

If `npm` is not on your PATH in this workspace, use the local Node binary:

```bash
PATH="$PWD/.local/node-v22.22.2-darwin-arm64/bin:$PATH" ./.local/node-v22.22.2-darwin-arm64/bin/npm run dev
```

## Build The Web Prototype

```bash
npm run build
```

Or with the local Node binary:

```bash
PATH="$PWD/.local/node-v22.22.2-darwin-arm64/bin:$PATH" ./.local/node-v22.22.2-darwin-arm64/bin/npm run build
```

## Open The iOS App

Open:

- `ios/AguaX0iPad.xcodeproj`

The app tries to load the live React dev server at `http://127.0.0.1:5173/` first.
If that is unavailable, it falls back to the bundled files in `ios/AguaX0iPad/Prototype/`.

## Notes For Collaborators

- The React prototype is the current source of truth for UI parity
- The iOS shell exists to let us validate the design inside Xcode and on iPad form factors
- `tmp/`, `dist/`, and local tool/runtime folders are ignored intentionally
