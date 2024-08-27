import XCTest
import Combine
@testable import DataLayer
@testable import DomainLayer

final class DiaryUseCaseTests: XCTestCase {

    private var useCase: DiaryUseCaseType!

    private var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        useCase = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testCallingServiceSpy() throws {

        // NOTE:
        // Integration level testing from `UseCase` -> `NetworkService`

        // GIVEN - network service that is a spy
        let serviceSpy = NetworkServiceSpy()
        useCase = DiaryUseCase(networkService: serviceSpy)

        let sampleDataBody = DiaryUseCaseMock.sampleData

        // WHEN - being requested to save & load data
        useCase.saveDiaryItem(sampleDataBody)
        .sink { _ in } receiveValue: { _ in
        }.store(in: &cancellables)

        // THEN - Spying works correctly to see what values are being hit

        // Spied call
        XCTAssertTrue(serviceSpy.loadResourceCalled)

        // Spied values
        XCTAssertNotNil(serviceSpy.url)
        XCTAssertEqual(
            serviceSpy.url?.absoluteString,
            "https://reqres.in/api/diary/newEntry"
        )
        XCTAssertNotNil(serviceSpy.parameters)
    }

    func testSavingSuccess() throws {

        var receivedError: NetworkError?
        var receivedResponse: Bool?

        // GIVEN - the useCase is made out of service mock that returns sample data
        let serviceMock = NetworkServiceMock(
            response: TestHelper.sampleDiaryEntry,
            returningError: false)
        useCase = DiaryUseCase(networkService: serviceMock)

        let sampleDataBody = DiaryUseCaseMock.sampleData

        // WHEN - being requested to save data
        useCase.saveDiaryItem(sampleDataBody)
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received response should be correct with `true` value
        let response = try XCTUnwrap(receivedResponse)
        XCTAssertTrue(response)

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testSavingFailure() {

        var receivedError: NetworkError?
        var receivedResponse: Bool?

        // GIVEN - the useCase is made out of service mock that returns `server` error
        let serviceMock = NetworkServiceMock(
            response: TestHelper.sampleDiaryEntry,
            returningError: true,
            error: .server
        )
        useCase = DiaryUseCase(networkService: serviceMock)

        let sampleDataBody = DiaryUseCaseMock.sampleData

        // WHEN - being requested to save data
        useCase.saveDiaryItem(sampleDataBody)
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - there should any error returned and it is expected `server` error
        XCTAssertEqual(receivedError, .server)

        // AND - Received data response should not arrive
        XCTAssertNil(receivedResponse)
    }
}
