import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var inclineLabel: WKInterfaceLabel!
    @IBOutlet weak var paceRecommendationLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // HealthKit 권한 요청
        HealthKitManager.shared.requestAuthorization { (success, error) in
            if success {
                // 실시간 데이터 수집 시작
                HealthKitManager.shared.startObservingHealthData()
                // 데이터 업데이트 알림 등록
                NotificationCenter.default.addObserver(self, selector: #selector(self.updateHealthData(_:)), name: .didReceiveHealthData, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.updatePaceRecommendation(_:)), name: .didReceivePaceRecommendation, object: nil)
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    @objc private func updateHealthData(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let heartRate = userInfo["heartRate"] as? Double,
           let temperature = userInfo["temperature"] as? Double,
           let incline = userInfo["incline"] as? Double {
            heartRateLabel.setText("Heart Rate: \(heartRate) BPM")
            temperatureLabel.setText("Temperature: \(temperature) °C")
            inclineLabel.setText("Incline: \(incline) %")
        }
    }
    
    @objc private func updatePaceRecommendation(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let recommendation = userInfo["recommendation"] as? String {
            paceRecommendationLabel.setText(recommendation)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension Notification.Name {
    static let didReceiveHealthData = Notification.Name("didReceiveHealthData")
    static let didReceivePaceRecommendation = Notification.Name("didReceivePaceRecommendation")
}
