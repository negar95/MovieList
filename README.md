# Searchable Movie List

## Overview
This project is a SwiftUI-based app that presents a searchable movie list interface. It fetches movie data using TheMovieDB API, allowing users to browse and search movies seamlessly.

## Technologies Used
- **Swift & Swift Concurrency (async/await)**: Provides clear, efficient asynchronous networking and concurrency management.
- **SwiftUI**: Enables declarative UI programming, ensuring smooth UI updates and reactive design.
- **MVVM Architecture**: Separates concerns cleanly by using a ViewModel to manage business logic and data flow.
- **URLSession**: Native Apple API for network requests, used here for API interaction and image loading.
- **Custom Network Layer**: Abstracted network requests via a `NetworkManager` protocol, enabling easy mocking and retry logic.
- **NSCache**: Used for efficient in-memory caching of images to improve performance and reduce memory usage.

## Features
- Search movies by query with debounced input handling.
- Pagination support to load more movies as users scroll.
- Movie detail overview display.
- Custom image loader with bearer-token authorization and optimized caching to prevent excessive memory usage.
- Robust error handling and state management for loading, error, and idle states.

## Changelog — Recent Updates

### Major Improvements
- Added a network package (`NetworkManager`) to centralize API calls with retry support and mocking for tests.
- Refactored all asynchronous API calls to use Swift's modern async/await syntax, improving readability and concurrency safety.
- Applied `@MainActor` to the ViewModel to guarantee all UI-bound state updates happen on the main thread.
- Implemented debounced search handling without Combine, relying on task cancellation and delays to minimize unnecessary network requests.
- Developed a custom `ImageLoader` with:
  - NSCache for efficient memory caching.
  - Downsampling of images on load to reduce memory footprint.
  - Support for authenticated requests via bearer tokens.
- Enhanced memory management to reduce spikes during fast scrolling by controlling image cache size and quality.
- Added comprehensive unit tests using Swift’s new Swift Testing framework with mock API services to verify ViewModel behavior including loading, searching, pagination, and clearing searches.
