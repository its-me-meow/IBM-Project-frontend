import HealthKit
import UserNotifications

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
    let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    let heightType = HKObjectType.quantityType(forIdentifier: .height)!
    let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
    let inclineType = HKObjectType.quantityType(forIdentifier: .stepCount)!

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let readTypes: Set<HKObjectType> = [heartRateType, bodyTemperatureType, activeEnergyBurnedType, heightType, bodyMassType, inclineType]
        let shareTypes: Set<HKSampleType> = [heartRateType, bodyTemperatureType, activeEnergyBurnedType, heightType, bodyMassType, inclineType]
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }

    func startObservingHealthData() {
        startObservingHeartRate()
        startObservingIncline()
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
                    let temperature = self?.getBodyTemperature()
                    let incline = self?.getIncline(from: sample)

                    let time = "\(Date())"

                    NetworkManager.shared.sendHealthData(
                        ecg: heartRate ?? 0,
                        temperature: temperature ?? 0,
                        vo2Max: 0, // Replace with real data if available
                        heartRate: Int(heartRate ?? 0),
                        incline: Int(incline ?? 0),
                        distanceCovered: 0.0, // Replace with real data if available
                        time: time,
                        completion: { (success: Bool, error: Error?) in
                            if success {
                                self?.fetchPaceRecommendation()
                                NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                    "heartRate": heartRate ?? 0,
                                    "temperature": temperature ?? 0,
                                    "incline": incline ?? 0
                                ])
                            } else {
                                print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    )
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
                    let temperature = self?.getBodyTemperature()

                    let time = "\(Date())"

                    NetworkManager.shared.sendHealthData(
                        ecg: heartRate ?? 0,
                        temperature: temperature ?? 0,
                        vo2Max: 0, // Replace with real data if available
                        heartRate: Int(heartRate ?? 0),
                        incline: Int(incline ?? 0),
                        distanceCovered: 0.0, // Replace with real data if available
                        time: time,
                        completion: { (success: Bool, error: Error?) in
                            if success {
                                self?.fetchPaceRecommendation()
                                NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                    "heartRate": heartRate ?? 0,
                                    "temperature": temperature ?? 0,
                                    "incline": incline ?? 0
                                ])
                            } else {
                                print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    )
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

    private func getHeartRate(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
    }

    private func getBodyTemperature() -> Double {
        // Implement logic to fetch body temperature
        return 0.0 // Placeholder
    }

    private func getIncline(from sample: HKQuantitySample) -> Double {
        // Implement logic to fetch incline
        return sample.quantity.doubleValue(for: HKUnit.count())
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
