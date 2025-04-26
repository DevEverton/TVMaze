# TVMaze iOS App

[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue.svg)](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVCandMVVM.html)

## Description

This iOS application allows users to browse, search, and view details about TV shows and their episodes, leveraging the [TVMaze API](https://www.tvmaze.com/api). Users can see a list of shows, view detailed information about a specific show including its seasons and episodes, and mark favorite shows (feature assumed, please verify/add details).

## Features

*   **Onboarding:** Simple onboarding flow for first-time users.
*   **Show Browsing:** Displays a paginated list of TV shows with basic information.
*   **Show Search:** Allows users to search for specific TV shows.
*   **Show Details:** Presents detailed information about a selected show, including summary, genres, schedule, and image.
*   **Episode List:** Shows a list of episodes organized by season for a selected show.
*   **Episode Details:** Displays details for a specific episode.
*   **SwiftUI Interface:** Modern and responsive UI built entirely with SwiftUI.
*   **Asynchronous Data Fetching:** Uses `async/await` for smooth network operations.

## Screenshots
### Lightmode
<img src="https://github.com/user-attachments/assets/70a2c581-176c-4f0f-b775-3f261fb00163" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/313a575c-1d81-46b0-814f-465fa5799c12" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/e5f41ef1-fefb-48b9-9d70-c304774bc226" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/daa49a35-c51c-4401-8e15-cebb1d52f537" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/2c3f0773-4751-4336-a3ec-be3e768e3109" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/6217698b-c887-49b9-9149-d9175afbc17e" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">

### Darkmode
<img src="https://github.com/user-attachments/assets/1511d1e9-901d-43b5-a68e-2175cd80fa6e" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/4e2bc974-f4be-427a-af0a-cbea6fdee73a" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/843c9509-f199-4d69-ab2f-51b56d725a17" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/288a9e8a-97ce-4983-999f-3cdc3c08a94b" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">
<img src="https://github.com/user-attachments/assets/1fa078f3-a447-4eaa-9d69-7842c04a867c" alt="Screenshot Description" style="width: 20%; height: auto; border-radius: 10px; display: block; margin-left: auto; margin-right: auto;">

## Technologies Used

*   **UI Framework:** SwiftUI
*   **Concurrency:** `async/await`
*   **State Management:** `@StateObject`, `@Published`, `@State`, `@AppStorage`
*   **Networking:** `URLSession`, `async/await` based custom `NetworkManager`.
*   **API:** TVMaze API
*   **Architecture:** MVVM (Model-View-ViewModel)

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern:

*   **Model:** Represents the data structures fetched from the TVMaze API (e.g., `Show`, `Episode`, `Season`). Located in the `Models/` directory.
*   **View:** SwiftUI views responsible for presenting the UI to the user (e.g., `ShowsListView`, `ShowDetailView`). Located in the `Views/` directory, organized by feature.
*   **ViewModel:** Acts as an intermediary between the Model and the View. It fetches and prepares data for the View and handles user interactions (e.g., `ShowsListViewModel`, `ShowDetailViewModel`). Located in the `ViewModels/` directory.
*   **Service:** Handles network requests and data fetching logic, interacting with the TVMaze API (e.g., `TVMazeService`, `NetworkManager`). Located in the `Services/` directory.
*   **Utils:** Contains helper functions, extensions, or common utilities used across the app. Located in the `Utils/` directory.

## Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/DevEverton/TVMaze.git
    cd TVMaze
    ```
2.  **Open the project:**
    Open `TVMaze.xcodeproj` in Xcode.
3.  **Build and Run:**
    Select a simulator or connect a device and press `Cmd + R` to build and run the application.


## Future Enhancements

*   [ ] Implement show favoriting persistence (e.g., using Core Data or SwiftData).
*   [ ] Add user authentication/profiles.
*   [ ] Improve error handling and user feedback.
*   [ ] Add unit and UI tests.
*   [ ] Implement pull-to-refresh on lists.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## License
Distributed under the MIT License. 
