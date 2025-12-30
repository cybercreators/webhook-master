# Discord Sender - iOS App

A sleek, modern iOS application for managing and automating Discord webhook messages.

## Features

- **Webhook Management**: Add, edit, and organize multiple Discord webhook URLs
- **Message Composer**: Craft messages with support for Discord markdown formatting
- **Interval Scheduler**: Set up automated messages to be sent at specific intervals
- **Flood Mode**: Rapid-fire message sending with configurable rate limits
- **Task Queue**: View and manage scheduled tasks with real-time status updates
- **Execution Logs**: Detailed history of sent messages with timestamps and status
- **Rate Limit Protection**: Built-in safeguards to prevent Discord API rate limiting

## Building with Codemagic

This project is configured to build an unsigned `.ipa` file using Codemagic CI/CD.

### Setup

1. Connect your GitHub repository to Codemagic
2. The `codemagic.yaml` will automatically build the unsigned `.ipa`
3. Download the `DiscordSender_Unsigned.ipa` from the artifacts

### Signing with KSign

After building, use KSign to sign the `.ipa` with your certificate:

1. Download the unsigned `.ipa` from Codemagic artifacts
2. Open KSign and import the `.ipa`
3. Select your certificate and provisioning profile
4. Sign and export the final `.ipa`

## Development

The app is built with SwiftUI and features:

- Elegant dark theme with gradient accents
- Tab-based navigation
- Real-time message sending
- Local task management

## Bundle ID

`com.sinotruk.cnhtc.discordsender`

## Team ID

`Y75T79946S`
