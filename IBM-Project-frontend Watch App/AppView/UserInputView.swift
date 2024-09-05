import SwiftUI

struct UserInputView: View {
    @State private var gender: String = "여"
    @State private var age: Int = 20
    @State private var experience: String = "초보자"
    @State private var goalDistance: Double = 5.0
    @State private var isRunningViewActive = false

    let genders = ["남", "여"]
    let runningLevels = ["초보자", "중급자", "숙련자"]
    
    let fakeDataSender = FakeDataSender() // FakeDataSender 인스턴스 생성

    var body: some View {
        NavigationView {
            VStack {
                Text("사용자 입력")
                    .font(.headline)
                    .padding(.top)
                
                Form {
                    Picker("성별", selection: $gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender)
                        }
                    }
                    
                    Picker("나이", selection: $age) {
                        ForEach(10...100, id: \.self) { age in
                            Text("\(age) 세")
                        }
                    }
                    
                    Picker("러닝 수준", selection: $experience) {
                        ForEach(runningLevels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    
                    HStack {
                        Text("목표 거리: \(goalDistance, specifier: "%.1f") km")
                        Slider(value: $goalDistance, in: 1...100, step: 0.1)
                    }
                    
                    Button(action: {
                        print("Running start button tapped") // 버튼 클릭 로그 출력
                        fakeDataSender.startSendingFakeData(age: age, gender: gender, experience: experience, goalDistance: goalDistance) // 러닝 시작 시 FakeDataSender 호출
                        isRunningViewActive = true
                    }) {
                        Text("러닝 시작")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink(destination: RunningView(distance: goalDistance), isActive: $isRunningViewActive) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView()
    }
}
