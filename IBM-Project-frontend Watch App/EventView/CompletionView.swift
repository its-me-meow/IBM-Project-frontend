import SwiftUI

struct CompletionView: View {
    var body: some View {
        ScrollView { // ScrollView로 전체 내용을 감싸 스크롤 가능하게 함
            VStack(spacing: 5) { // 요소들 간의 간격을 좁혀서 상단 공백 줄이기
                Text("축하합니다!")
                    .font(.title2) // 폰트 크기를 조정하여 모든 텍스트가 화면에 나타나도록
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center) // 텍스트 가운데 정렬
                    .padding(.top, 5) // 상단에 여백을 줄여 텍스트를 더 위로 올림

                Text("목표한 러닝 거리를 완주했습니다!")
                    .font(.body) // 폰트 크기를 줄여 화면에 맞추기
                    .multilineTextAlignment(.center) // 텍스트 가운데 정렬
                    .padding(.horizontal) // 좌우 여백 추가로 텍스트가 양쪽에 붙지 않도록

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 이미지 비율 유지하며 크기 조정
                    .frame(width: 20, height: 20) // 이미지 크기 유지
                    .foregroundColor(.green)

                Spacer() // 아래 여유 공간 추가로 "메인 화면으로 돌아가기" 버튼을 아래로 밀어냄

                Button(action: {
                    // 메인 화면으로 돌아가는 동작 구현
                }) {
                    Text("메인 화면으로 돌아가기")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20) // 버튼 하단 여백을 최소화
            }
            .frame(maxWidth: .infinity) // 가로 폭을 최대한 늘려서 버튼이 화면 가장자리에 붙지 않도록 함
            .padding(.horizontal) // 전체 VStack의 좌우 여백 추가
        }
    }
}

struct CompletionView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionView()
    }
}
