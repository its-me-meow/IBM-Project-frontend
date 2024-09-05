import SwiftUI
import UserNotifications
import AVFoundation

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
            
            Text("Pace: \(pace)")
                .font(.title3)
                .padding()

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
                if let userInfo = notification.userInfo, let recommendationDict = userInfo["recommendation"] as? String {
                    let newRecommendation = self.parseRecommendation(recommendationDict)
                    if self.previousRecommendation != newRecommendation {
                        self.recommendation = newRecommendation
                        self.previousRecommendation = newRecommendation
                        self.isNotificationActive = true
                        self.sendNotification(with: newRecommendation)
                        self.speakRecommendation(newRecommendation)
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
    
    private func parseRecommendation(_ recommendationDict: String) -> String {
        // JSON 문자열에서 recommendation 값만 추출
        if let data = recommendationDict.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
           let recommendation = json["recommendation"] {
            return recommendation
        }
        return recommendationDict
    }

    private func sendNotification(with text: String) {
        let content = UNMutableNotificationContent()
        content.title = "페이스 변경 알림"
        content.body = text
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    private func speakRecommendation(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(distance: 5.0)
    }
}
