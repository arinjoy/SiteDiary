import Foundation
import Combine

public final class NetworkServiceSpy: NetworkServiceType {

    // Spy calls
    public var loadResourceCalled = false

    // Spy values
    public var url: URL?
    public var parameters: [(String, CustomStringConvertible)]?
    public var request: URLRequest?
    public var dataBody: Encodable?

    public func save<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {

        loadResourceCalled = true

        url = resource.url
        parameters = resource.parameters
        request = resource.request
        dataBody = resource.body

        return Empty().eraseToAnyPublisher()
    }
}

public final class NetworkServiceMock<ResponseType>: NetworkServiceType {

    /// The pre-determined response to always return from this mock no matter what request is made
    public let response: ResponseType

    /// Whether to return error outcome
    public let returningError: Bool

    /// The pre-determined error to return if `returnError` is set true
    public let error: NetworkError

    public init(
        response: ResponseType,
        returningError: Bool = false,
        error: NetworkError = NetworkError.unknown
    ) {
        self.response = response
        self.returningError = returningError
        self.error = error
    }

    public func save<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {

        if returningError {
            return .fail(error)
        }

        return .just(response as! T) // swiftlint:disable:this force_cast
    }
}
