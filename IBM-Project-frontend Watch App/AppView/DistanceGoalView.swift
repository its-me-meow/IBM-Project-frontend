
import SwiftUI

struct DistanceGoalView: View {
    @State private var distance: Double = 1.0

    var body: some View {
        VStack {
            Text("러닝 목표 거리를 설정하세요")
                .font(.headline)
                .padding()

            Text("\(distance, specifier: "%.1f") km")
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    if distance > 1.0 {
                        distance -= 1.0
                    }
                }) {
                    Text("-")
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding()

                Button(action: {
                    distance += 1.0
                }) {
                    Text("+")
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding()
            }

            NavigationLink(destination: RunningView(distance: distance)) {
                Text("러닝 시작")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct DistanceGoalView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceGoalView()
    }
}
