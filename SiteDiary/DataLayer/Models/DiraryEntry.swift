import Foundation

public struct DiaryEntry: Codable {

    // Images are encoded as base64 strings
    public let images: [String]

    public let comments: String
    public let areaName: String
    public let taskName: String
    public let tags: [String]
    public let existingEventName: String?
    public let timestamp: Date

}
