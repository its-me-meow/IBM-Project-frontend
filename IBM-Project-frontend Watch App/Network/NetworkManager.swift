import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: "https://42171c02-b743-4f5e-806a-2f13e9043369-00-szxespj90i05.pike.replit.dev/api/send-data")!

    func sendHealthData(timestamp: String, age: Int, gender: String, heartRate: Double, incline: Double, experience: String, goalDistance: Double, distanceCovered: Double, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "timestamp": timestamp,
            "age": age,
            "gender": gender,
            "heartRate": heartRate,
            "incline": incline,
            "experience": experience,
            "goalDistance": goalDistance,
            "distanceCovered": distanceCovered
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
