import SwiftUI

struct UserInputView: View {

    @State private var gender: String = "여"
    @State private var age: Int = 20
    @State private var runningLevel: String = "초보자"
    @State private var distance: Int = 5

    let genders = ["남", "여"]
    let runningLevels = ["초보자", "중급자", "숙련자"]

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
                    
                    Picker("러닝 수준", selection: $runningLevel) {
                        ForEach(runningLevels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    
                    HStack {
                        Text("목표 거리: \(distance) km")
                        Slider(value: Binding(get: {
                            Double(distance)
                        }, set: { newValue in
                            distance = Int(newValue)
                        }), in: 1...100, step: 1.0)
                    }
                    
                    NavigationLink(destination: RunningView(distance: distance)) {
                        Text("러닝 시작")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
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
