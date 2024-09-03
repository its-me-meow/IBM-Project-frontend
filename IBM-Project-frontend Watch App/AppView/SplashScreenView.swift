import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if isActive {
                    // UserInputView로 전환
                    UserInputView()
                } else {
                    // 스플래시 화면
                    Image(systemName: "figure.run") // SF Symbols 사용
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5) // 이미지 크기 조정
                        .foregroundColor(.green) // 이미지 색상 설정
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // 전체 화면을 차지하도록 설정
        }
        .edgesIgnoringSafeArea(.all) // 전체 화면을 덮도록 설정
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
