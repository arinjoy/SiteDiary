import Foundation

public struct Resource<E: Encodable, D: Decodable> {

    // MARK: - Properties

    let url: URL
    let parameters: [(String, CustomStringConvertible)]

    let body: Encodable

    // MARK: - Initializer

    public init(
        url: URL,
        parameters: [(String, CustomStringConvertible)] = [],
        body: Encodable
    ) {
        self.url = url
        self.parameters = parameters
        self.body = body
    }

    // MARK: - Helper

    var request: URLRequest? {
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }

        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value.description)
        }

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        return request
    }

}
