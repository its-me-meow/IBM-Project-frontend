import SwiftUI

struct UserInputView: View {
    @State private var gender: String = "여"
    @State private var age: Int = 20  // Picker로 입력받기 위해 Int로 변경
    @State private var height: Int = 170
    @State private var weight: Int = 60
    
    let genders = ["남", "여", "none"]
    
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
        }
    }
}
struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView()
    }
}
