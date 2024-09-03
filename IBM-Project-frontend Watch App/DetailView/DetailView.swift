//
//  DetailView.swift
//  IBM-Project-frontend Watch App
//
//  Created by Suin Kim on 9/1/24.
//

import SwiftUI
import HealthKit

struct DetailView: View {
    var detail: String
    @State private var healthData: String = "Loading..."
    
    // HealthKit 데이터를 위한 프로퍼티
    private let healthStore = HKHealthStore()
    private var heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    private var bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature)!
    private var ecgType = HKObjectType.electrocardiogramType()
    private var vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max)!
    
    init(detail: String) {
        self.detail = detail
    }
    
    var body: some View {
        VStack {
            Text(detail)
                .font(.headline)
                .padding()
            
            if detail == "심전도" {
                // 심전도 그래프와 코멘트
                Image(systemName: "waveform.path.ecg")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(healthData)
                    .padding()
                    .onAppear {
                        requestAuthorization {
                            fetchECGData()
                        }
                    }
            } else if detail == "체온" {
                // 체온 정보
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
                // VO2 max 정보
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
                // 심박수 정보
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
            
            // 돌아가기 버튼
            Button(action: {
                // 현재 네비게이션 스택에서 이전 화면으로 돌아가기
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    // HealthKit 권한 요청
    private func requestAuthorization(completion: @escaping () -> Void) {
        let typesToShare: Set<HKSampleType> = []
        let typesToRead: Set<HKObjectType> = [heartRateType, bodyTemperatureType, ecgType, vo2MaxType]
        
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
    
    // 심박수 데이터 가져오기
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
    
    // 체온 데이터 가져오기
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
    
    // VO2 max 데이터 가져오기
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
    
    // 심전도 데이터 가져오기
    private func fetchECGData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: ecgType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKElectrocardiogram], let sample = samples.first else {
                DispatchQueue.main.async {
                    healthData = "No data available"
                }
                return
            }
            DispatchQueue.main.async {
                healthData = "ECG Data: \(sample)"
            }
        }
        healthStore.execute(query)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detail: "")
    }
}
