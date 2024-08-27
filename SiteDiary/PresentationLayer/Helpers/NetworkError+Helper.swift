import DataLayer

extension NetworkError {

    // NOTE: Map more custom error messages if needed
    /// such `serviceUnavailable`, `forbidden` etc.
    /// based on the use cases and granularity of messaging required.
    ///
    var title: String {
        switch self {
        case .networkFailure:
            return "You're offline!"
        default:
            return "Something went wrong!"
        }
    }

    var message: String {
        switch self {
        case .networkFailure:
            return "Please connect to the Internet and try again."
        default:
            return "Please try again later."
        }
    }
}

