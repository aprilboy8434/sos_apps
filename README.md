# OneTapSOS

OneTapSOS is a SwiftUI iOS app (iOS 16+) that lets you quickly send an emergency message to multiple destinations with a single tap.

## Features

- Large pulsing red **SOS** button on the main screen.
- On tap, the app attempts to fetch your current location and builds a message:
  ```
  SOS! I need help. Location: <Apple Maps link> (lat, lon) at <timestamp>
  ```
- Sends the message to every configured destination using its URL scheme.
- Records successes and failures and shows a results sheet with share/copy options.
- Status line indicates last sent time.
- Haptic feedback and VoiceOver support.
- Settings screen for managing destinations (add/edit/delete, quick‑add templates).
- Export destinations as QR codes or deep links and import via camera or pasted code.
- Handles `onetapsos://import?payload=<base64url>` deep links.

## Adding Destinations

Open Settings (gear icon) and use the plus button:

- Choose one of the quick‑add templates (SMS, WhatsApp, LINE, Telegram, Email) or create a custom destination.
- Each destination requires a URL template containing `{MESSAGE}` where the encoded SOS message will be inserted.
- Examples:
  - `sms:&body={MESSAGE}`
  - `whatsapp://send?text={MESSAGE}`

## QR Export & Import

### Export
- From a destination row or edit screen choose **Share as QR**.
- For multiple destinations, enter edit mode, select items, and tap **Share as QR (N)**.
- A QR code and deep link (`onetapsos://import?payload=...`) are generated. Share or copy the link.

### Import
- In Settings tap **Import from QR** to open the camera scanner.
- Alternatively paste a deep link or code starting with `OTS:` into the scanner.
- The Import Preview shows the destinations with toggles and conflict indicators.
- Confirm to add them to your list. Duplicates (same name and template) are skipped.

## Limitations

- The app can only open URLs that the system recognizes. It cannot send arbitrary messages to apps without appropriate URL schemes.
- Location acquisition may fail; messages are still sent without coordinates.
- QR scanning requires camera permission. A manual paste option is provided if permission is denied.

---

Enjoy quick emergency sharing with OneTapSOS.
