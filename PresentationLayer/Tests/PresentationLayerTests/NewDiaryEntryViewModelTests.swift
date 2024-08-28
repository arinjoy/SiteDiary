import XCTest
import SwiftUI
import Combine
@testable import DataLayer
@testable import DomainLayer
@testable import PresentationLayer

@MainActor
final class NewDiaryEntryViewModelTests: XCTestCase {

    // MARK: - Properties

    private var testSubject: NewDiaryEntryViewModel!

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        testSubject = NewDiaryEntryViewModel(useCase: DiaryUseCaseMock())
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        testSubject = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testInitialIdleState() {
        XCTAssertEqual(testSubject.state, .idle)
    }

    func testInvalidInputState() {

        let expectation = expectation(description: "Diary entry item to be saved")

        // WHEN - mandatory inputs are not filled in yet and saving action is triggered
        testSubject.saveDiaryItem(
            from: [],
            comments: "",
            area: "",
            task: "",
            tagsString: "",
            linkedEvent: nil)

        testSubject.$state.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - viewModel's state should become `invalidInput`
        XCTAssertEqual(testSubject.state, .failure(.invalidInput))
    }

    func testSavingTriggersLoadingState() {
        let expectation = expectation(description: "Diary entry item to be saved")

        // WHEN - saving action is triggered
        testSubject.saveDiaryItem(
            from: [Image(systemName: "star"), Image(systemName: "cross")],
            comments: "a comment",
            area: "Area #1",
            task: "Task A",
            tagsString: "tag1, tag2, tag3",
            linkedEvent: "Event 1")

        testSubject.$state.sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - viewModel's state should become `loading`
        XCTAssertEqual(testSubject.state, .loading)
    }

    func testSavingSuccessfulAfterLoadingState() {
        let expectation = expectation(description: "Diary entry item to be saved")

        // GIVEN - useCase is configured to succeed without error
        testSubject = .init(useCase: DiaryUseCaseMock(returningError: false))

        // WHEN - saving action is triggered
        testSubject.saveDiaryItem(
            from: [Image(systemName: "star"), Image(systemName: "cross")],
            comments: "a comment",
            area: "Area #1",
            task: "Task A",
            tagsString: "tag1, tag2, tag3",
            linkedEvent: "Event 1")

        testSubject.$state.dropFirst(1).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - viewModel's state should become `loading`
        XCTAssertEqual(testSubject.state, .success)
    }

    func testSavingFailureAfterLoadingState() {
        let expectation = expectation(description: "Diary entry item to be saved")

        // GIVEN - useCase is configured to return an error
        testSubject = .init(useCase: DiaryUseCaseMock(returningError: true, error: .networkFailure))

        // WHEN - saving action is triggered
        testSubject.saveDiaryItem(
            from: [Image(systemName: "star"), Image(systemName: "cross")],
            comments: "a comment",
            area: "Area #1",
            task: "Task A",
            tagsString: "tag1, tag2, tag3",
            linkedEvent: "Event 1")

        testSubject.$state.dropFirst(1).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - viewModel's state should become `failure`
        switch testSubject.state {
        case .failure(let reason):
            // AND - retuned associated error is same as returned by useCase
            XCTAssertEqual(reason, .networkIssue(.networkFailure))
        default:
            XCTFail("Loading state must become `failure`")
        }
    }

    // MARK: - Test copies / strings

    func testCopies() {
        XCTAssertEqual(testSubject.headerTitle, "Add to site diary")
        XCTAssertEqual(testSubject.photosSectionHeaderTitle, "Add photos to site diary")
        XCTAssertEqual(testSubject.commentSectionTitle, "Comments")
        XCTAssertEqual(testSubject.detailsSectionTitle, "Details")
        XCTAssertEqual(testSubject.addPhotoButtonTitle, "Add a photo")

        // TODO: Finish the rest of the tests for other copies
        // These tests are useful if string copies get updated in the centralised
        // `.strings` files. If viewModel reads from there, then unit tests can catch
        // any inadvertent or mistaken copy update
    }

}
