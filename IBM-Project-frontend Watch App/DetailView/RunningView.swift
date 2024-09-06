import SwiftUI

struct RunningView: View {
    var distance: Double
    @State private var timer: Timer?
    @State private var pace: String = "Loading..."
    @State private var isNotificationActive = false
    @State private var recommendation: String = ""
    @State private var previousRecommendation: String = "" // 이전 recommendation 저장
    private let fakeDataSender = FakeDataSender() // FakeDataSender 인스턴스 생성

    var body: some View {
        VStack {
            Text("Goal: \(distance, specifier: "%.1f") km")
                .font(.title3)
                .padding(.top)

            HStack(spacing: 10) {
                NavigationLink(destination: DetailView(detail: "경사")) {
                    Image(systemName: "arrow.up.right.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary)
                }
                
                NavigationLink(destination: DetailView(detail: "체온")) {
                    Image(systemName: "thermometer")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary)
                }
                
                NavigationLink(destination: DetailView(detail: "VO2 max")) {
                    Image(systemName: "lungs.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary)
                }
                
                NavigationLink(destination: DetailView(detail: "심박수")) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top, 20)
            
            NavigationLink(
                destination: NotificationView(recommendation: recommendation),
                isActive: $isNotificationActive,
                label: {
                    EmptyView()
                }
            )
        }
        .onAppear {
            startFakeDataSender()
            NotificationCenter.default.addObserver(forName: .didReceivePaceRecommendation, object: nil, queue: .main) { notification in
                if let userInfo = notification.userInfo, let newRecommendation = userInfo["recommendation"] as? String {
                    if self.previousRecommendation != newRecommendation {
                        self.recommendation = newRecommendation
                        self.previousRecommendation = newRecommendation
                        self.isNotificationActive = true
                    }
                }
            }
        }
        .onDisappear {
            stopFakeDataSender()
            NotificationCenter.default.removeObserver(self, name: .didReceivePaceRecommendation, object: nil)
        }
    }

    private func startFakeDataSender() {
        fakeDataSender.startSendingFakeData(age: 25, gender: "male", experience: "beginner", goalDistance: distance)
    }

    private func stopFakeDataSender() {
        fakeDataSender.stopSendingFakeData()
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(distance: 5.0)
    }
}
