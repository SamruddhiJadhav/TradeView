🧱 Architecture MVVM with @ObservableObject for state management. 
WebSocketManager, A singleton actor that manages the socket connection and streams. 
Uses AsyncThrowingStream to deliver WebSocket messages in a structured way. 
Handles error logging. 
TradeViewApp is acting as Compostion Root.

⚙️ Technologies 
✅ Swift Concurrency (async/await) 
✅ URLSession WebSocket ✅ SwiftUI + MVVM 
✅ Custom WebSocketManager 
✅ Modular, testable code


Possible Improvements (if extended further)

Unit tests for mappers and socket handling. 
Add Fonts and Spacing to Theme. 
Currently logs are added for errors, we can handle errors and show user the errors. 
In Recent Trades we can show some message or ProgressView when screen is empty and waiting for messages. 
Combine with persistence for offline viewing. Real-time charts.
