import SwiftUI
import HealthKit

struct DetailView: View {
    var detail: String
    @State private var healthData: String = "Loading..."

    private let healthStore = HKHealthStore()
    private var heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    private var bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
    private var ecgType = HKObjectType.electrocardiogramType()
    private var vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max)!
    private var inclineType = HKObjectType.quantityType(forIdentifier: .stepCount)!

    init(detail: String) {
        self.detail = detail
    }

    var body: some View {
        VStack {
            Text(detail)
                .font(.headline)
                .padding()

            if detail == "경사" {
                Image(systemName: "arrow.up.right.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(healthData)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchInclineData()
                        }
                    }
            } else if detail == "체온" {
                Image(systemName: "thermometer")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(healthData)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchBodyTemperatureData()
                        }
                    }
            } else if detail == "VO2 max" {
                Image(systemName: "lungs.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(healthData)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchVO2MaxData()
                        }
                    }
            } else if detail == "심박수" {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(healthData)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchHeartRateData()
                        }
                    }
            }
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    @Environment(\.presentationMode) var presentationMode

    private func requestAuthorization(completion: @escaping () -> Void) {
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [heartRateType, bodyTemperatureType, ecgType, vo2MaxType, inclineType]

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
        // Implementation for fetching incline data
        // This is a placeholder and needs to be replaced with actual implementation
        DispatchQueue.main.async {
            healthData = "Incline: 0.0" // Replace with actual data fetching logic
        }
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

    private func fetchBodyTemperatureData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: bodyTemperatureType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
                DispatchQueue.main.async {
                    healthData = "No data available"
                }
                return
            }
            let temperature = sample.quantity.doubleValue(for: HKUnit.degreeCelsius())
            DispatchQueue.main.async {
                healthData = "Body Temperature: \(temperature) °C"
            }
        }
        healthStore.execute(query)
    }

    private func fetchVO2MaxData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let sample = samples.first else {
                DispatchQueue.main.async {
                    healthData = "No data available"
                }
                return
            }
            let vo2Max = sample.quantity.doubleValue(for: HKUnit(from: "ml/kg·min"))
            DispatchQueue.main.async {
                healthData = "VO2 Max: \(vo2Max) ml/kg·min"
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
