import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: "http://localhost:3000/api/send-data")!

    func sendInitialData(gender: String, age: Int, distance: Int, runningLevel: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/initial-data"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "gender": gender,
            "age": age,
            "goalDistance": distance,
            "experience": runningLevel
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

    func sendHealthData(ecg: Double, temperature: Double, vo2Max: Double, heartRate: Int, incline: Int, distanceCovered: Double, time: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("/health-data"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "ecg": ecg,
            "temperature": temperature,
            "vo2Max": vo2Max,
            "heartRate": heartRate,
            "incline": incline,
            "distanceCovered": distanceCovered,
            "time": time
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
