import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {

    let healthStore = HKHealthStore()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        requestHealthKitAuthorization()
    }

    // HealthKit 권한 요청
    func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }

        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
                return
            }

            if success {
                print("HealthKit authorization granted")
                self.readHeartRateData()
            } else {
                print("HealthKit authorization denied")
            }
        }
    }

    // 심박수 데이터 읽기
    func readHeartRateData() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("HeartRate type is no longer available in HealthKit")
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                print("Error reading heart rate data: \(error.localizedDescription)")
                return
            }

            guard let samples = samples as? [HKQuantitySample] else {
                print("No heart rate samples available")
                return
            }

            for sample in samples {
                let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                let startDate = sample.startDate
                print("Heart Rate: \(heartRate) BPM at \(startDate)")
            }
        }

        healthStore.execute(query)
    }
}
