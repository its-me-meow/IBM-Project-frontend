import SwiftUI
import AVFoundation

struct NotificationView: View {
    let recommendation: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(extractPace(from: recommendation))
                .font(.headline)
                .padding()
                .onAppear {
                    speakText(extractPace(from: recommendation))
                }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("확인")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func extractPace(from recommendation: String) -> String {
        // JSON 문자열에서 pace recommendation 값만 추출
        if let data = recommendation.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
           let pace = json["pace recommendation"] {
            return pace
        }
        return recommendation
    }

    private func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(recommendation: "{\"pace recommendation\": \"maintain pace\"}")
    }
}
