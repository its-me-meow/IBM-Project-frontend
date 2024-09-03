import SwiftUI

struct RunningView: View {
    var distance: Double

    var body: some View {
        VStack {
            Text("러닝 중...")
                .font(.largeTitle)
                .padding()

            Text("목표 거리: \(distance, specifier: "%.1f") km")
                .font(.headline)
                .padding()

            NavigationLink(destination: DetailView(distance: distance)) {
                Text("러닝 종료")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct RunningView_Previews: PreviewProvider {
    static var previews: some View {
        RunningView(distance: 5.0)
    }
}
