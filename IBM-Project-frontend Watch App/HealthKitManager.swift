import HealthKit
import UserNotifications

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let inclineType = HKObjectType.quantityType(forIdentifier: .stepCount)!
    let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max)!

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let readTypes: Set<HKObjectType> = [heartRateType, inclineType, vo2MaxType]
        let shareTypes: Set<HKSampleType> = [heartRateType, inclineType, vo2MaxType]
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }

    func startObservingHealthData() {
        startObservingHeartRate()
        startObservingIncline()
        startObservingVO2Max()
    }

    private func startObservingHeartRate() {
        let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [weak self] (query, completionHandler, error) in
            if let error = error {
                print("Failed to set up observer: \(error.localizedDescription)")
                return
            }
            self?.fetchLatestHeartRateSample(completion: { (sample) in
                if let sample = sample {
                    let heartRate = self?.getHeartRate(from: sample)
                    let incline = self?.getIncline(from: sample)
                    let vo2max = self?.getVO2Max(from: sample)

                    let timestamp = "\(Date())" // Current time as a string

                    NetworkManager.shared.sendHealthData(
                        timestamp: timestamp,
                        age: 25, // Replace with real data
                        gender: "male", // Replace with real data
                        heartRate: heartRate ?? 0,
                        incline: incline ?? 0,
                        vo2max: vo2max ?? 0,
                        experience: "beginner", // Replace with real data
                        goalDistance: 5.0, // Replace with real data
                        distanceCovered: 0.0 // Replace with real data
                    ) { (success: Bool, error: Error?) in
                        if success {
                            self?.fetchPaceRecommendation()
                            NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                "heartRate": heartRate ?? 0,
                                "incline": incline ?? 0,
                                "vo2max": vo2max ?? 0
                            ])
                        } else {
                            print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
                completionHandler()
            })
        }
        
        healthStore.execute(query)
    }

    private func startObservingIncline() {
        let inclineSampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKObserverQuery(sampleType: inclineSampleType, predicate: nil) { [weak self] (query, completionHandler, error) in
            if let error = error {
                print("Failed to set up observer: \(error.localizedDescription)")
                return
            }
            self?.fetchLatestInclineSample(completion: { (sample) in
                if let sample = sample {
                    let incline = self?.getIncline(from: sample)
                    let heartRate = self?.getHeartRate(from: sample) // Replace with real data fetching logic
                    let vo2max = self?.getVO2Max(from: sample)

                    let timestamp = "\(Date())" // Current time as a string

                    NetworkManager.shared.sendHealthData(
                        timestamp: timestamp,
                        age: 25, // Replace with real data
                        gender: "male", // Replace with real data
                        heartRate: heartRate ?? 0,
                        incline: incline ?? 0,
                        vo2max: vo2max ?? 0,
                        experience: "beginner", // Replace with real data
                        goalDistance: 5.0, // Replace with real data
                        distanceCovered: 0.0 // Replace with real data
                    ) { (success: Bool, error: Error?) in
                        if success {
                            self?.fetchPaceRecommendation()
                            NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                "heartRate": heartRate ?? 0,
                                "incline": incline ?? 0,
                                "vo2max": vo2max ?? 0
                            ])
                        } else {
                            print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
                completionHandler()
            })
        }
        
        healthStore.execute(query)
    }

    private func startObservingVO2Max() {
        let vo2MaxSampleType = HKObjectType.quantityType(forIdentifier: .vo2Max)!
        
        let query = HKObserverQuery(sampleType: vo2MaxSampleType, predicate: nil) { [weak self] (query, completionHandler, error) in
            if let error = error {
                print("Failed to set up observer: \(error.localizedDescription)")
                return
            }
            self?.fetchLatestVO2MaxSample(completion: { (sample) in
                if let sample = sample {
                    let vo2max = self?.getVO2Max(from: sample)

                    let timestamp = "\(Date())" // Current time as a string

                    NetworkManager.shared.sendHealthData(
                        timestamp: timestamp,
                        age: 25, // Replace with real data
                        gender: "male", // Replace with real data
                        heartRate: 0, // Replace with real data
                        incline: 0, // Replace with real data
                        vo2max: vo2max ?? 0,
                        experience: "beginner", // Replace with real data
                        goalDistance: 5.0, // Replace with real data
                        distanceCovered: 0.0 // Replace with real data
                    ) { (success: Bool, error: Error?) in
                        if success {
                            self?.fetchPaceRecommendation()
                            NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                "vo2max": vo2max ?? 0
                            ])
                        } else {
                            print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
                completionHandler()
            })
        }
        
        healthStore.execute(query)
    }

    private func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        let heartRateSampleType = HKSampleType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateSampleType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (_, samples, error) in
            if let error = error {
                print("Failed to fetch heart rate sample: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(samples?.first as? HKQuantitySample)
        }
        
        healthStore.execute(query)
    }

    private func fetchLatestInclineSample(completion: @escaping (HKQuantitySample?) -> Void) {
        let inclineSampleType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: inclineSampleType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (_, samples, error) in
            if let error = error {
                print("Failed to fetch incline sample: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(samples?.first as? HKQuantitySample)
        }
        
        healthStore.execute(query)
    }

    private func fetchLatestVO2MaxSample(completion: @escaping (HKQuantitySample?) -> Void) {
        let vo2MaxSampleType = HKSampleType.quantityType(forIdentifier: .vo2Max)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: vo2MaxSampleType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (_, samples, error) in
            if let error = error {
                print("Failed to fetch VO2 Max sample: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(samples?.first as? HKQuantitySample)
        }
        
        healthStore.execute(query)
    }

    private func getHeartRate(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
    }

    private func getIncline(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit.count())
    }

    private func getVO2Max(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit(from: "ml/kg/min"))
    }

    private func fetchPaceRecommendation() {
        NetworkManager.shared.fetchPaceRecommendation { (recommendation: String?, error: Error?) in
            if let recommendation = recommendation {
                self.notifyUser(with: recommendation)
                NotificationCenter.default.post(name: .didReceivePaceRecommendation, object: nil, userInfo: [
                    "recommendation": recommendation
                ])
            } else {
                print("Failed to fetch pace recommendation: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func notifyUser(with recommendation: String) {
        let content = UNMutableNotificationContent()
        content.title = "Pace Recommendation"
        content.body = recommendation
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
