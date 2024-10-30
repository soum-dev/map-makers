# Favorite Places App

This Flutter app allows users to interact with a map, save their favorite places, and manage them. Using the Google Maps and Places API, the app provides a seamless experience for marking locations, searching for places, and displaying them on a map. Users can also view a list of their saved places and remove them if desired.

## Table of Contents
- [Features](#features)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Google API Key Setup](#google-api-key-setup)
  - [Installation](#installation)
- [Usage](#usage)
- [Screens](#screens)
- [Authors](#authors)
- [License](#license)

## Features
- **Maps Screen**: Users can view their favorite places as markers on a Google Map. Each marker has an info view displaying the place's name.
- **Current Location**: A button allows users to navigate to their current location on the map.
- **Search**: Users can search for places and navigate to them using the Google Places API.
- **Favorite Places**: The app persists favorite places even after it is closed, allowing users to manage their list of favorite places.
- **Info Screen**: Displays the names, email addresses of the app's authors, and a general description of the app.

## Setup Instructions

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Google Cloud Project](https://console.cloud.google.com/) for accessing Google Maps and Places APIs
- API keys for Google Maps and Places APIs

### Google API Key Setup
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project and enable the **Google Maps JavaScript API** and **Google Places API**.
3. Generate an API key and note it down.
4. Add your API key to the appropriate files:
   - In **AndroidManifest.xml**:
     ```xml
     <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>
     <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
     <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
     ```
   - In **info.plist** for iOS:
     ```xml
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Your app needs access to your location to display favorite places on the map.</string>
     <key>NSLocationAlwaysUsageDescription</key>
     <string>Your app needs access to your location to display favorite places on the map.</string>
     ```

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/favorite_places_app.git
   cd favorite_places_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on your preferred device or emulator:
   ```bash
   flutter run
   ```

## Usage
- **Maps Screen**: View all saved places on the map. Use the search bar to find and add new locations. Tap a marker to view place details.
- **Favorite Places Screen**: Swipe right on a place to delete it from your list of saved places.
- **Info Screen**: View the developers’ information and a general description of the app.

## Screens

1. **Maps Screen**:
   - Displays Google Maps with saved favorite places marked.
   - A button allows navigation to the user's current location.
   - Search for new places using the integrated Google Places API.

2. **Favorite Places Screen**:
   - Lists all favorite places.
   - Swipe right to delete a place from the list.

3. **Info Screen**:
   - Shows the developers' names, email addresses, and app description.

## Authors
- **Developer 1**: [Mouhamed Soumare (soum-dev)] - [mouhamedsoumare70@gmail.com]
- **Year of Development**: 2024

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

