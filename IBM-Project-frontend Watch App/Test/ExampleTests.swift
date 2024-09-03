//import XCTest
//import HealthKit
//@testable import YourApp
//
//class ExampleTests: XCTestCase {
//
//    func testHeartRateFetching() {
//        let expectation = self.expectation(description: "Heart Rate Fetching")
//        HealthKitManager.shared.fetchLatestHeartRateSample { sample in
//            XCTAssertNotNil(sample, "Heart rate sample should not be nil")
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//
//    func testPaceRecommendationFetching() {
//        let expectation = self.expectation(description: "Pace Recommendation Fetching")
//        NetworkManager.shared.fetchPaceRecommendation { recommendation, error in
//            XCTAssertNotNil(recommendation, "Pace recommendation should not be nil")
//            XCTAssertNil(error, "Error should be nil")
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//}
