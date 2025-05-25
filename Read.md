
A lightweight iOS app to view real-time Order Book and Recent Trades for the XBTUSD pair using the BitMEX WebSocket API.


🧱 Architecture
MVVM with @ObservableObject for state management.
WebSocketManager: A singleton actor that manages the socket connection and streams.
Uses AsyncThrowingStream to deliver WebSocket messages in a structured way.
Handles reconnect attempts and error logging.
                                                                            
⚙️ Technologies
✅ Swift Concurrency (async/await)
✅ URLSession WebSocket
✅ SwiftUI + MVVM
✅ Custom WebSocketManager
✅ Modular, testable code
                                                                            
📲 Screens
Order Book          Recent Trades
Live asks & bids    Streaming trades list
                                                                            
🔁 Known Trade-Offs / Simplifications
The app does not cancel the message stream when the user navigates away from a screen (e.g., Order Book or Recent Trades).
In a production app, we would cancel the listener Task in onDisappear() to reduce memory use and avoid redundant processing.
For this demo, keeping the stream active simplifies the socket lifecycle without introducing stale reconnect issues.
Socket disconnect/reconnect is kept minimal for brevity and to keep the focus on core functionality.
                                                                            
                                                                            
✅ Possible Improvements (if extended further)
Graceful handling of stream cancellation per feature (Order Book vs Trades)
Add user-selectable pairs (BTC/USD, ETH/USD, etc.)
Combine with persistence for offline viewing
Real-time charts
Unit tests for mappers and socket handling
