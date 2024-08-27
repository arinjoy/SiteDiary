import Foundation
import Combine

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

    public func saveDiaryEntry(_ entry: DiaryEntry) async throws {

        try await networkService
            .save(Resource<DiaryEntry>.create(entry))
            // TODO: must be removed in production
            // This delay is added for testing & visualisation only
            .delay(for: .seconds(1), scheduler: Scheduler.main)
            .eraseToAnyPublisher()
            .async()
    }

}
