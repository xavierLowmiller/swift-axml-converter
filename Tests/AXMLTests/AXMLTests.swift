import XCTest
@testable import AXML

final class AXMLTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AXML().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
