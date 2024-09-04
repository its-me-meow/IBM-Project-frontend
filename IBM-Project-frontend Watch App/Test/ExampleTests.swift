import XCTest
@testable import IBM-Project-frontend; // 실제 앱 모듈 이름으로 변경

class ExampleTests: XCTestCase {

    func testSendingFakeData() {
        let expectation = self.expectation(description: "Sending fake data to backend")

        let fakeDataSender = FakeDataSender()
        fakeDataSender.startSendingFakeData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            fakeDataSender.stopSendingFakeData()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 70, handler: nil)
    }
}
