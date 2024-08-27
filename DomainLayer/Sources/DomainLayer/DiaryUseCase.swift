import Foundation
import Combine
import DataLayer
import SharedUtils

final public class DiaryUseCase: DiaryUseCaseType {

    // MARK: - Properties

    private let networkService: NetworkServiceType

    // MARK: - Initializer

    public init(
        networkService: NetworkServiceType = ServicesProvider.defaultProvider().network
    ) {
        self.networkService = networkService
    }

    // MARK: - DiaryUseCaseType

    public func saveDiaryItem(_ item: DiaryItem) -> AnyPublisher<Bool, NetworkError> {

        // Note: Add any Domain level business logic for data transformation here
        // One example is the comma based string split logic to extract individual tags
        // In reality, there can be multiple types of business rules can be incorporated here

        let entry = DiaryEntry(
            images: item.images,
            comments: item.comments,
            areaName: item.area,
            taskName: item.task,
            tags: item.tagsString.components(separatedBy: ",").map { $0.trimmed() },
            existingEventName: item.linkedEvent,
            timestamp: Date.now)

        return networkService
            .save(Resource<DiaryEntry>.create(entry))
            .map { _ in true }
            .eraseToAnyPublisher()
    }

}
