import Foundation

class FakeDataSender {
    private var timer: Timer?
    private var dataIndex = 0
    private let fakeData: [[String: Any]] = [
        ["timestamp": "2024-09-04T10:00:00Z", "heartRate": 85, "incline": 1, "distanceCovered": 0.00, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:01Z", "heartRate": 86, "incline": 1, "distanceCovered": 0.01, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:02Z", "heartRate": 87, "incline": 1, "distanceCovered": 0.02, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:03Z", "heartRate": 88, "incline": 1, "distanceCovered": 0.03, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:04Z", "heartRate": 89, "incline": 1, "distanceCovered": 0.04, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:05Z", "heartRate": 90, "incline": 1, "distanceCovered": 0.05, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:06Z", "heartRate": 91, "incline": 1, "distanceCovered": 0.06, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:07Z", "heartRate": 92, "incline": 1, "distanceCovered": 0.07, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:08Z", "heartRate": 93, "incline": 1, "distanceCovered": 0.08, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:09Z", "heartRate": 94, "incline": 1, "distanceCovered": 0.09, "vo2max": 35],
        ["timestamp": "2024-09-04T10:00:10Z", "heartRate": 95, "incline": 1, "distanceCovered": 0.10, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:11Z", "heartRate": 96, "incline": 1, "distanceCovered": 0.11, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:12Z", "heartRate": 97, "incline": 1, "distanceCovered": 0.12, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:13Z", "heartRate": 98, "incline": 1, "distanceCovered": 0.13, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:14Z", "heartRate": 99, "incline": 1, "distanceCovered": 0.14, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:15Z", "heartRate": 100, "incline": 1, "distanceCovered": 0.15, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:16Z", "heartRate": 101, "incline": 1, "distanceCovered": 0.16, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:17Z", "heartRate": 102, "incline": 1, "distanceCovered": 0.17, "vo2max": 36],
        ["timestamp": "2024-09-04T10:00:18Z", "heartRate": 103, "incline": 1, "distanceCovered": 0.18, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:19Z", "heartRate": 104, "incline": 1, "distanceCovered": 0.19, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:20Z", "heartRate": 105, "incline": 2, "distanceCovered": 0.20, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:21Z", "heartRate": 106, "incline": 2, "distanceCovered": 0.21, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:22Z", "heartRate": 107, "incline": 2, "distanceCovered": 0.22, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:23Z", "heartRate": 108, "incline": 2, "distanceCovered": 0.23, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:24Z", "heartRate": 109, "incline": 2, "distanceCovered": 0.24, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:25Z", "heartRate": 110, "incline": 2, "distanceCovered": 0.25, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:26Z", "heartRate": 111, "incline": 2, "distanceCovered": 0.26, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:27Z", "heartRate": 112, "incline": 2, "distanceCovered": 0.27, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:28Z", "heartRate": 113, "incline": 2, "distanceCovered": 0.28, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:29Z", "heartRate": 114, "incline": 2, "distanceCovered": 0.29, "vo2max": 37],
        ["timestamp": "2024-09-04T10:00:30Z", "heartRate": 115, "incline": 2, "distanceCovered": 0.30, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:31Z", "heartRate": 116, "incline": 2, "distanceCovered": 0.31, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:32Z", "heartRate": 117, "incline": 2, "distanceCovered": 0.32, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:33Z", "heartRate": 118, "incline": 2, "distanceCovered": 0.33, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:34Z", "heartRate": 119, "incline": 2, "distanceCovered": 0.34, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:35Z", "heartRate": 120, "incline": 2, "distanceCovered": 0.35, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:36Z", "heartRate": 121, "incline": 2, "distanceCovered": 0.36, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:37Z", "heartRate": 122, "incline": 2, "distanceCovered": 0.37, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:38Z", "heartRate": 123, "incline": 2, "distanceCovered": 0.38, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:39Z", "heartRate": 124, "incline": 2, "distanceCovered": 0.39, "vo2max": 38],
        ["timestamp": "2024-09-04T10:00:40Z", "heartRate": 125, "incline": 3, "distanceCovered": 0.40, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:41Z", "heartRate": 126, "incline": 3, "distanceCovered": 0.41, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:42Z", "heartRate": 127, "incline": 3, "distanceCovered": 0.42, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:43Z", "heartRate": 128, "incline": 3, "distanceCovered": 0.43, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:44Z", "heartRate": 129, "incline": 3, "distanceCovered": 0.44, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:45Z", "heartRate": 130, "incline": 3, "distanceCovered": 0.45, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:46Z", "heartRate": 131, "incline": 3, "distanceCovered": 0.46, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:47Z", "heartRate": 132, "incline": 3, "distanceCovered": 0.47, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:48Z", "heartRate": 133, "incline": 3, "distanceCovered": 0.48, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:49Z", "heartRate": 134, "incline": 3, "distanceCovered": 0.49, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:50Z", "heartRate": 135, "incline": 3, "distanceCovered": 0.50, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:51Z", "heartRate": 136, "incline": 3, "distanceCovered": 0.51, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:52Z", "heartRate": 137, "incline": 3, "distanceCovered": 0.52, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:53Z", "heartRate": 138, "incline": 3, "distanceCovered": 0.53, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:54Z", "heartRate": 139, "incline": 3, "distanceCovered": 0.54, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:55Z", "heartRate": 140, "incline": 3, "distanceCovered": 0.55, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:56Z", "heartRate": 141, "incline": 3, "distanceCovered": 0.56, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:57Z", "heartRate": 142, "incline": 3, "distanceCovered": 0.57, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:58Z", "heartRate": 143, "incline": 3, "distanceCovered": 0.58, "vo2max": 39],
        ["timestamp": "2024-09-04T10:00:59Z", "heartRate": 144, "incline": 3, "distanceCovered": 0.59, "vo2max": 39]
    ]

    func startSendingFakeData() {
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
        timer?.invalidate()
        timer = nil
    }

    private func sendData(data: [String: Any]) {
        guard let heartRate = data["heartRate"] as? Int,
              let incline = data["incline"] as? Int,
              let distanceCovered = data["distanceCovered"] as? Double,
              let vo2max = data["vo2max"] as? Int,
              let time = data["timestamp"] as? String else {
            return
        }

        NetworkManager.shared.sendHealthData(heartRate: heartRate, incline: incline, distanceCovered: distanceCovered, vo2max: vo2max, time: time) { success, error in
            if success {
                print("Data sent successfully: \(data)")
            } else {
                print("Failed to send data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
