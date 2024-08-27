import XCTest
@testable import DataLayer

final class DiaryEntryJSONDecodingTests: XCTestCase {

    private var testJSONData: Data!

    private let jsonDecoder = JSONDecoder()

    // MARK: - Tests

    func testMappingSuccess() throws {

        // GIVEN - a valid JSON file with sample diary entry
        testJSONData = TestHelper.jsonData(forResource: "diary_entry_valid")

        // WHEN - trying to decode the JSON into `DiaryEntry`
        let mappedItem = try XCTUnwrap(jsonDecoder.decode(DiaryEntry.self, from: testJSONData))

        // THEN - the outcome should be mapped from the data

        XCTAssertEqual(mappedItem.images.count, 2)
        XCTAssertEqual(mappedItem.images[0], "string1")
        XCTAssertEqual(mappedItem.images[1], "string2")
        XCTAssertEqual(mappedItem.comments, "some comment")
        XCTAssertEqual(mappedItem.areaName, "some area name")
        XCTAssertEqual(mappedItem.taskName, "some task name")
        XCTAssertEqual(mappedItem.tags[0], "tag1")
        XCTAssertEqual(mappedItem.tags[1], "tag2")
        XCTAssertEqual(mappedItem.tags[2], "tag3")
    }

    func testMappingFailure() {

        // GIVEN - a invalid JSON structure
        testJSONData = TestHelper.jsonData(forResource: "diary_entry_invalid")

        // WHEN - trying to decode the JSON into `DiaryEntry`
        let mappedItem = try? jsonDecoder.decode(DiaryEntry.self, from: testJSONData)

        // THEN - outcome cannot be mapped
        XCTAssertNil(mappedItem)
    }
}

