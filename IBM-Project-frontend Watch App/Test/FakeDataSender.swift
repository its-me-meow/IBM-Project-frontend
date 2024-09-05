import Foundation

class FakeDataSender {
    private var timer: Timer?
    private var dataIndex = 0
    private var fakeData: [[String: Any]] = []

    func generateFakeData(age: Int, gender: String, experience: String, goalDistance: Double) {
        // 초기값 설정
        var heartRate = 85.0
        var incline = 1.0
        var distanceCovered = 0.0
        let timestampFormatter = ISO8601DateFormatter()

        // 페이크 데이터 생성
        for second in 0..<60 {
            let timestamp = timestampFormatter.string(from: Date().addingTimeInterval(TimeInterval(second)))
            let data: [String: Any] = [
                "timestamp": timestamp,
                "age": age,
                "gender": gender,
                "heartRate": heartRate,
                "incline": incline,
                "experience": experience,
                "goalDistance": goalDistance,
                "distanceCovered": distanceCovered
            ]
            fakeData.append(data)

            // 심박수와 거리 증가, 경사도는 20초마다 증가
            heartRate += 0.5
            distanceCovered += goalDistance / 60
            if second % 20 == 0 {
                incline += 1.0
            }
        }
    }

    func startSendingFakeData(age: Int, gender: String, experience: String, goalDistance: Double) {
        // 페이크 데이터 생성
        generateFakeData(age: age, gender: gender, experience: experience, goalDistance: goalDistance)
        
        print("Starting to send fake data...") // 시작 로그 출력
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.dataIndex < self.fakeData.count {
                let data = self.fakeData[self.dataIndex]
                self.sendData(data: data)
                self.dataIndex += 1
            } else {
                self.stopSendingFakeData()
            }
        }
    }
    
    func stopSendingFakeData() {
        print("Stopping fake data sender...") // 종료 로그 출력
        timer?.invalidate()
        timer = nil
    }
    
    private func sendData(data: [String: Any]) {
        guard let timestamp = data["timestamp"] as? String,
              let age = data["age"] as? Int,
              let gender = data["gender"] as? String,
              let heartRate = data["heartRate"] as? Double,
              let incline = data["incline"] as? Double,
              let experience = data["experience"] as? String,
              let goalDistance = data["goalDistance"] as? Double,
              let distanceCovered = data["distanceCovered"] as? Double else {
            return
        }
        
        print("Sending data: \(data)")  // 네트워크 요청 전 로그 출력
        
        NetworkManager.shared.sendHealthData(
            timestamp: timestamp,
            age: age,
            gender: gender,
            heartRate: heartRate,
            incline: incline,
            experience: experience,
            goalDistance: goalDistance,
            distanceCovered: distanceCovered
        ) { success, error in
            if success {
                print("Data sent successfully: \(data)")
            } else {
                print("Failed to send data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
