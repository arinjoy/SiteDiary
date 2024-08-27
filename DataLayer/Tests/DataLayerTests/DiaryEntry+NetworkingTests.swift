import XCTest
import Combine
@testable import DataLayer

final class DiaryEntryNetworkingTests: XCTestCase {

    var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        super.tearDown()
    }

    // MARK: - Tests

    func testSpyLoadingResource() throws {

        // GIVEN - network service that is a spy
        let networkServiceSpy = NetworkServiceSpy()

        // WHEN - saving of desired resource type
        _ = networkServiceSpy
            .save(Resource<DiaryEntry>.create(TestHelper.sampleDiaryEntry))

        // THEN - Spying works correctly to see what values are being hit

        // Spied call
        XCTAssertTrue(networkServiceSpy.loadResourceCalled)

        // Spied values
        XCTAssertNotNil(networkServiceSpy.url)
        XCTAssertEqual(
            networkServiceSpy.url?.absoluteString,
            "https://reqres.in/api/diary/newEntry"
        )

        XCTAssertNotNil(networkServiceSpy.parameters)
        XCTAssertEqual(networkServiceSpy.parameters?.count, 0)

        XCTAssertNotNil(networkServiceSpy.request)
    }

    func testSuccessfulLoading() throws {
        var receivedError: NetworkError?
        var receivedResponse: DiaryEntry?

        // GIVEN - network service that is a Mock with sample list successfully without error
        let networkServiceMock = NetworkServiceMock(response: TestHelper.sampleDiaryEntry, returningError: false)

        // WHEN - saving of desired resource type
        networkServiceMock
            .save(Resource<DiaryEntry>.create(TestHelper.sampleDiaryEntry))
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received diary response should be correct
        XCTAssertNotNil(receivedResponse)

        XCTAssertEqual(receivedResponse?.images.count, 2)
        XCTAssertEqual(receivedResponse?.images[0], "string1")
        XCTAssertEqual(receivedResponse?.images[1], "string2")
        XCTAssertEqual(receivedResponse?.comments, "some comment")
        XCTAssertEqual(receivedResponse?.areaName, "some area name")
        XCTAssertEqual(receivedResponse?.taskName, "some task name")
        XCTAssertEqual(receivedResponse?.tags[0], "tag1")
        XCTAssertEqual(receivedResponse?.tags[1], "tag2")
        XCTAssertEqual(receivedResponse?.tags[2], "tag3")

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testFailureLoading() throws {
        var receivedError: NetworkError?
        var receivedResponse: DiaryEntry?

        // GIVEN - network service that to return an `.notFound` error
        let networkServiceMock = NetworkServiceMock(
            response: TestHelper.sampleDiaryEntry,
            returningError: true,
            error: .notFound
        )

        // WHEN - saving of desired resource type
        networkServiceMock
            .save(Resource<DiaryEntry>.create(TestHelper.sampleDiaryEntry))
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - there should be an error returned
        XCTAssertNotNil(receivedError)

        // AND - error type is desired
        XCTAssertEqual(receivedError, .notFound)

        // AND - diary response should not be returned
        XCTAssertNil(receivedResponse)
    }

}
