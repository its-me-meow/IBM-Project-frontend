import SwiftUI

struct RunningView: View {
    var distance: Int
    @State private var timer: Timer?
    @State private var pace: String = "Loading..."

    var body: some View {
        VStack {
            Text("Running...")
                .font(.headline)
                .padding()

            Text("Goal: \(distance) km")
                .font(.largeTitle)
                .padding()
            
            Text("Pace: \(pace)")
                .font(.title)
                .padding()

            HStack {
                NavigationLink(destination: DetailView(detail: "경사")) {
                    VStack {
                        Image(systemName: "arrow.up.right.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("경사")
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
            let heartRate = 0 // Replace with real data
            let incline = 0 // Replace with real data
            let distanceCovered = 0.0 // Replace with real data
            let vo2max = 0 // Replace with real data
            let time = "\(Date())" // Current time as a string

            NetworkManager.shared.sendHealthData(
                ecg: Double(heartRate),
                temperature: Double(incline),
                vo2Max: Double(vo2max),
                heartRate: heartRate,
                incline: incline,
                distanceCovered: distanceCovered,
                time: time
            ) { success, error in
                if success {
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
