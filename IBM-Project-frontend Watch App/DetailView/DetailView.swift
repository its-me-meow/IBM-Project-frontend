import SwiftUI
import HealthKit

struct DetailView: View {
    var detail: String
    @State private var healthData: String = "Loading..."

    private let healthStore = HKHealthStore()
    private var heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    private var inclineType = HKObjectType.quantityType(forIdentifier: .stepCount)!

    init(detail: String) {
        self.detail = detail
    }

    var body: some View {
        VStack {
            Text(detail)
                .font(.title2)
                .padding(.bottom, 30)

            if detail == "경사" {
                Image(systemName: "arrow.up.right.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                Text(healthData)
                    .font(.title3)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchInclineData()
                        }
                    }
            } else if detail == "심박수" {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                Text(healthData)
                    .font(.title3)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchHeartRateData()
                        }
                    }
            } else if detail == "체온" {
                Image(systemName: "thermometer")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                Text(healthData)
                    .font(.title3)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchHeartRateData()
                        }
                    }
            } else if detail == "VO2 max" {
                Image(systemName: "lungs.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                Text(healthData)
                    .font(.title3)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchHeartRateData()
                        }
                    }
            } 
            
            Spacer()
            
        }
    }

    @Environment(\.presentationMode) var presentationMode

    private func requestAuthorization(completion: @escaping () -> Void) {
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [heartRateType, inclineType]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success {
                completion()
            } else {
                DispatchQueue.main.async {
                    healthData = "Authorization failed"
                }
            }
        }
    }

    private func fetchInclineData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: inclineType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
                DispatchQueue.main.async {
                    healthData = "No data available"
                }
                return
            }
            let incline = sample.quantity.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                healthData = "Incline: \(incline)"
            }
        }
        healthStore.execute(query)
    }

    private func fetchHeartRateData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
                DispatchQueue.main.async {
                    healthData = "No data available"
                }
                return
            }
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                healthData = "Heart Rate: \(heartRate) BPM"
            }
        }
        healthStore.execute(query)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detail: "경사")
    }
}
