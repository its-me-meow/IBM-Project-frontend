
import SwiftUI

struct UserInputView: View {
    @State private var gender: String = "여"
    @State private var age: Int = 20
    @State private var height: Int = 170
    @State private var weight: Int = 60
    
    let genders = ["남", "여"]
    
    var body: some View {
        NavigationView { // NavigationView 추가
            Form { // Form을 NavigationView 바로 아래에 사용
                Section(header: Text("측정에 필요한 정보를 입력해 주세요").font(.headline)) {
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

                    Picker("신장", selection: $height) {
                        ForEach(140...220, id: \.self) { height in
                            Text("\(height) cm")
                        }
                    }

                    Picker("몸무게", selection: $weight) {
                        ForEach(40...150, id: \.self) { weight in
                            Text("\(weight) kg")
                        }
                    }
                }

                Section {
                    NavigationLink(destination: DistanceGoalView()) {
                        Text("다음")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center) // 버튼 너비를 최대화
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle()) // watchOS에서는 기본 버튼 스타일을 사용하지 않도록 설정
                }
            }
            .navigationTitle("입력") // NavigationView의 타이틀 설정
        }
    }
}

struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView()
    }
}
