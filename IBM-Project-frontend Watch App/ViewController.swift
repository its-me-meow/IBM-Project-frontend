import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 웹소켓 연결 시작
        WebSocketManager.shared.connect()
    }
    
    deinit {
        // 웹소켓 연결 종료
        WebSocketManager.shared.disconnect()
    }
}
