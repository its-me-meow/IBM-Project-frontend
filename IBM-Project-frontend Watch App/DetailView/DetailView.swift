import SwiftUI

struct DetailView: View {
    var detail: String
    @State private var healthData: String = "Loading..."
    @State private var timer: Timer?
    private let fakeDataSender = FakeDataSender()
    
    var body: some View {
        VStack {
            Text(detail)
                .font(.title2)
                .padding()
            
            Text(healthData)
                .font(.subheadline)
                .padding(.bottom)
                .font(.body) // 폰트 크기를 조정하여 텍스트를 더 작게 만듦
        }
        .onAppear {
            startFakeDataSender()
        }
        .onDisappear {
            stopFakeDataSender()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private func startFakeDataSender() {
        fakeDataSender.generateFakeData(age: 25, gender: "male", experience: "beginner", goalDistance: 5.0)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateData()
        }
        fakeDataSender.startSendingFakeData(age: 25, gender: "male", experience: "beginner", goalDistance: 5.0)
    }
    
    private func stopFakeDataSender() {
        fakeDataSender.stopSendingFakeData()
        timer?.invalidate()
        timer = nil
    }
    
    private func updateData() {
        guard fakeDataSender.dataIndex < fakeDataSender.fakeData.count else {
            stopFakeDataSender()
            return
        }
        
        let data = fakeDataSender.fakeData[fakeDataSender.dataIndex]
        switch detail {
        case "경사":
            if let incline = data["incline"] as? Double {
                self.healthData = String(format: "%.1f", incline)
            }
        case "체온":
            if let heartRate = data["heartRate"] as? Double {
                self.healthData = String(format: "%.1f BPM", heartRate)
            }
        case "VO2 max":
            if let vo2max = data["vo2max"] as? Double {
                self.healthData = String(format: "%.1f mL/kg/min", vo2max)
            }
        case "심박수":
            if let heartRate = data["heartRate"] as? Double {
                self.healthData = String(format: "%.1f", heartRate)
            }
        default:
            self.healthData = "No data available"
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detail: "경사")
    }
}
