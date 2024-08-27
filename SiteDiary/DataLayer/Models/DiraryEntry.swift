import Foundation

public struct DiaryEntry: Codable {

    public let comments: String
    public let areaName: String
    public let taskName: String
    public let tags: [String]
    public let existingEventName: String?
    public let timestamp: Date

}
