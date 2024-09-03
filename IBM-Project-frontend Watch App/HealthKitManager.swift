import HealthKit
import UserNotifications

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    // 요청할 데이터 타입 설정
    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
    let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    let heightType = HKObjectType.quantityType(forIdentifier: .height)!
    let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!

    // HealthKit 권한 요청
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let readTypes: Set<HKObjectType> = [heartRateType, bodyTemperatureType, activeEnergyBurnedType, heightType, bodyMassType]
        let shareTypes: Set<HKSampleType> = [heartRateType, bodyTemperatureType, activeEnergyBurnedType, heightType, bodyMassType]
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }

    // 실시간 데이터 수집 시작
    func startObservingHealthData() {
        startObservingHeartRate()
        // 체온 및 경사도 관찰 로직도 추가
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
                    let temperature = self?.getBodyTemperature() // 체온을 가져오는 로직 추가
                    let incline = self?.getIncline() // 경사도를 가져오는 로직 추가

                    // NetworkManager를 통해 데이터를 백엔드로 전송
                    NetworkManager.shared.sendHealthData(
                        ecg : heartRate ?? 0,
                        temperature: heartRate ?? 0,
                        vo2Max: incline ?? 0,// 정확한 매개변수 이름 사용
                        heartRate: temperature ?? 0,
                        incline: incline ?? 0
                    ) { (success: Bool, error: Error?) in
                        if success {
                            self?.fetchPaceRecommendation() // 페이스 조절 권장 사항을 요청
                            // 실시간 데이터 업데이트 알림
                            NotificationCenter.default.post(name: .didReceiveHealthData, object: nil, userInfo: [
                                "heartRate": heartRate ?? 0,
                                "temperature": temperature ?? 0,
                                "incline": incline ?? 0
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

    private func getHeartRate(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
    }

    private func getBodyTemperature() -> Double {
        // 체온 데이터를 수집하는 로직 구현
        return 0.0 // 예시 값
    }

    private func getIncline() -> Double {
        // 경사도 데이터를 수집하는 로직 구현
        return 0.0 // 예시 값
    }

    private func fetchPaceRecommendation() {
        NetworkManager.shared.fetchPaceRecommendation { (recommendation: String?, error: Error?) in
            if let recommendation = recommendation {
                self.notifyUser(with: recommendation)
                // 페이스 권장 사항 업데이트 알림
                NotificationCenter.default.post(name: .didReceivePaceRecommendation, object: nil, userInfo: [
                    "recommendation": recommendation
                ])
            } else {
                print("Failed to fetch pace recommendation: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func notifyUser(with recommendation: String) {
        // 사용자에게 알림 및 소리로 권장 사항 전달
        let content = UNMutableNotificationContent()
        content.title = "Pace Recommendation"
        content.body = recommendation
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
