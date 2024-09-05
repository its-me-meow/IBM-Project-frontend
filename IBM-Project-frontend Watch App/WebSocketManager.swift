import Foundation

class WebSocketManager {
    static let shared = WebSocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "https://42171c02-b743-4f5e-806a-2f13e9043369-00-szxespj90i05.pike.replit.dev/ws")!

    private init() {}

    func connect() {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        print("WebSocket connection established")
        receiveMessages()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket connection closed")
    }

    func send(message: String) {
        let textMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(textMessage) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            } else {
                print("Message sent: \(message)")
            }
        }
    }

    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received WebSocket message: \(text)")
                    // Handle the received message (update UI, etc.)
                default:
                    print("Received non-string WebSocket message")
                }
                self?.receiveMessages()
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            }
        }
    }
}
