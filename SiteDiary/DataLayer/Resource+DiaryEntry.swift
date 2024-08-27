import Foundation

extension Resource {

    public static func create(_ entry: DiaryEntry) -> Resource<DiaryEntry> {
        let url = ApiConstants.baseUrl
        let parameters: [(String, CustomStringConvertible)] = []
        return Resource<DiaryEntry>(url: url, parameters: parameters, body: entry)
    }
}
