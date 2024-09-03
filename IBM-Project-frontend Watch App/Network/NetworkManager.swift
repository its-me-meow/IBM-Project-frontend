import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: "https://your-backend-server.com/api")! // 백엔드 서버 URL을 설정하세요.

    // HealthKit 데이터를 백엔드로 전송하는 함수
    func sendHealthData(heartRate: Double, temperature: Double, incline: Double, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/health-data"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "heartRate": heartRate,
            "temperature": temperature,
            "incline": incline
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, nil)
                return
            }

            completion(true, nil)
        }

        task.resume()
    }

    // 페이스 조절 권장 사항을 백엔드로부터 가져오는 함수
    func fetchPaceRecommendation(completion: @escaping (String?, Error?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/pace-recommendation"))
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil, nil)
                return
            }

            let recommendation = String(data: data, encoding: .utf8)
            completion(recommendation, nil)
        }

        task.resume()
    }
}
