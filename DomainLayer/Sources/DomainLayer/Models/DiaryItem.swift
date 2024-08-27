import Foundation

public struct DiaryItem {

    public let images: [String] // A list of images represented as base64 encoded strings
    public let comments: String
    public let area: String
    public let task: String
    public let tagsString: String
    public let linkedEvent: String?

    public init(
        images: [String],
        comments: String,
        area: String,
        task: String,
        tagsString: String,
        linkedEvent: String?
    ) {
        self.images = images
        self.comments = comments
        self.area = area
        self.task = task
        self.tagsString = tagsString
        self.linkedEvent = linkedEvent
    }
}
