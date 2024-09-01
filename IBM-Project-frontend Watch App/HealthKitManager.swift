import HealthKit

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
}

extension HealthKitManager {

    // 실시간 데이터 수집 시작
    func startObservingHeartRate() {
        let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [weak self] (query, completionHandler, error) in
            if let error = error {
                print("Failed to set up observer: \(error.localizedDescription)")
                return
            }
            self?.fetchLatestHeartRateSample(completion: { (sample) in
                if let sample = sample {
                    let heartRate = self?.getHeartRate(from: sample)
                    print("Heart Rate: \(heartRate ?? 0) BPM")
                    // 여기에 백엔드로 데이터를 전송하는 로직 추가
                }
                completionHandler()
            })
        }
        
        healthStore.execute(query)
    }

    // 최신 심박수 샘플 가져오기
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

    // 심박수 값을 가져오는 함수
    private func getHeartRate(from sample: HKQuantitySample) -> Double {
        return sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
    }
}
