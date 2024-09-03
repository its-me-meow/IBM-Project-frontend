import SwiftUI

struct RunningView: View {
    var distance: Double
    @State private var timer: Timer?
    @State private var pace: String = "Loading..."

    var body: some View {
        VStack {
            Text("Running...")
                .font(.headline)
                .padding()

            Text("Goal: \(distance, specifier: "%.1f") km")
                .font(.largeTitle)
                .padding()
            
            Text("Pace: \(pace)")
                .font(.title)
                .padding()

            HStack {
                NavigationLink(destination: DetailView(detail: "심전도")) {
                    VStack {
                        Image(systemName: "waveform.path.ecg")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("심전도")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "체온")) {
                    VStack {
                        Image(systemName: "thermometer")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("체온")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "VO2 max")) {
                    VStack {
                        Image(systemName: "lungs.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("VO2 max")
                    }
                }
                .padding()

                NavigationLink(destination: DetailView(detail: "심박수")) {
                    VStack {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("심박수")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            // 여기서 실시간 건강 데이터를 가져와 백엔드로 전송합니다.
            let ecg = 0.0 // Replace with real data
            let temperature = 0.0 // Replace with real data
            let vo2Max = 0.0 // Replace with real data
            let heartRate = 0.0 // Replace with real data
            let incline = 0.0 // Replace with real data
            
            NetworkManager.shared.sendHealthData(ecg: ecg, temperature: temperature, vo2Max: vo2Max, heartRate: heartRate, incline: incline) { success, error in
                if success {
                    // 페이스 조절 권장 사항을 받아옴
                    NetworkManager.shared.fetchPaceRecommendation { recommendation, error in
                        if let recommendation = recommendation {
                            DispatchQueue.main.async {
                                pace = recommendation
                            }
                        } else {
                            print("Failed to fetch pace recommendation: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                } else {
                    print("Failed to send health data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
