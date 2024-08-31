import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("측정에 필요한 정보를 입력해 주세요")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                NavigationLink(destination: UserInputView()) {
                    Text("정보 입력 시작")
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

// 프리뷰 제공자 추가
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
