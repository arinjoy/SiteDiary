import Foundation
import Combine
import SharedUtils
import DataLayer

// MARK: - UseCase Spy

public final class DiaryUseCaseSpy: DiaryUseCaseType {

    // Spied calls
    public var saveItemCalled: Bool = false

    // Spied values
    public var item: DiaryItem?

    public func saveDiaryItem(_ item: DiaryItem) async throws {
        saveItemCalled = true
        self.item = item
    }

    public func saveDiaryItem(_ item: DiaryItem) -> AnyPublisher<Bool, NetworkError> {
        saveItemCalled = true
        self.item = item
        return .empty()
    }
}

 // MARK: - UseCase Mock

public final class DiaryUseCaseMock: DiaryUseCaseType {

    public var returningError: Bool
    public var error: NetworkError

    init(
        returningError: Bool = false,
        error: NetworkError = .unknown
    ) {
        self.returningError = returningError
        self.error = error
    }

    public func saveDiaryItem(_ item: DiaryItem) async throws {
        if returningError {
            throw error
        }
    }

    public func saveDiaryItem(_ item: DiaryItem) -> AnyPublisher<Bool, NetworkError> {
        if returningError {
            return .fail(error)
        }
        return .just(true).eraseToAnyPublisher()
    }

    // MARK: - Sample Test data

    public static let sampleData = DiaryItem(
        images: ["string1", "string2"],
        comments: "some comment",
        area: "some area",
        task: "some task",
        tagsString: "tag1, tag2, tag3",
        linkedEvent: "some event"
    )
}

