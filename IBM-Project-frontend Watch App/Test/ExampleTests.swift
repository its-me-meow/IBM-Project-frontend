import XCTest
@testable import IBM_Project_frontend_Watch_App // 실제 앱 모듈 이름으로 변경

class ExampleTests: XCTestCase {

    func testSendingFakeData() {
        let expectation = self.expectation(description: "Sending fake data to backend")

        let fakeDataSender = FakeDataSender()
        fakeDataSender.startSendingFakeData(age: 25, gender: "male", experience: "beginner", goalDistance: 5.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            fakeDataSender.stopSendingFakeData()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 70, handler: nil)
    }
}
