import Foundation
import Combine
import DataLayer
import SharedUtils

// TODO: Extract these content of the `DomainLayer` folder as SPM local module
// Hence many things declared public to access across package boundary

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

    public func saveDiaryItem(_ item: DiaryItem) async throws {

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

        try await networkService
            .save(Resource<DiaryEntry>.create(entry))
            // TODO: must be removed in production
            // This delay is added for testing & visualisation only
            .delay(for: .seconds(1), scheduler: Scheduler.main)
            .eraseToAnyPublisher()
            .async()
    }

}
