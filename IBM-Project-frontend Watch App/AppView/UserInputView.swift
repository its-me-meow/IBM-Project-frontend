import SwiftUI

struct UserInputView: View {
    @State private var gender: String = "여"
    @State private var age: Int = 20  // Picker로 입력받기 위해 Int로 변경
    @State private var height: Int = 170
    @State private var weight: Int = 60
    @State private var runningLevel: String = "초보자"
    @State private var distance: Double = 5.0
    @State private var isDataSent: Bool = false
    
    let genders = ["남", "여", "none"]
    let runningLevels = ["초보자", "중급자", "숙련자"]
    
    var body: some View {
        VStack {
            Text("사용자 입력")
                .font(.headline)
                .padding(.top) // 상단 여백 추가

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

                Picker("러닝 수준", selection: $runningLevel) {
                    ForEach(runningLevels, id: \.self) { level in
                        Text(level)
                    }
                }

                HStack {
                    Text("목표 거리: \(distance, specifier: "%.1f") km")
                    Slider(value: $distance, in: 1...100, step: 0.1)
                }
            }
            
            Button(action: {
                // 초기 데이터를 백엔드로 전송
                NetworkManager.shared.sendInitialData(gender: gender, age: age, distance: distance, runningLevel: runningLevel) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            isDataSent = true
                        }
                    } else {
                        print("Failed to send initial data: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }) {
                Text("데이터 전송")
                    .font(.headline)
                    .padding()
                    .background(isDataSent ? Color.gray : Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .disabled(isDataSent) // 데이터가 전송된 후 버튼 비활성화
        }
    }
}

struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView()
    }
}
