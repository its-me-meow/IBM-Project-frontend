import SwiftUI

struct NotificationView: View {
    let recommendation: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(recommendation)
                .font(.headline)
                .padding()

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
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(recommendation: "페이스를 변경하세요!")
    }
}
