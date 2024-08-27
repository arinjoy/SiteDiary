import Foundation

extension Resource {

    public static func saveDiaryEntry(_ entry: DiaryEntry) -> Resource<DiaryEntry, DiaryEntry> {
        let url = ApiConstants.baseUrl
        let parameters: [(String, CustomStringConvertible)] = []
        return Resource<DiaryEntry, DiaryEntry>(url: url, parameters: parameters, body: entry)
    }
}
