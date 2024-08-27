import Foundation

// A domain level representation of the Diary Item
// Note: This data structure can be different to data layer's model which are used for
// coding/decoding purposes

public struct DiaryItem {

    // A list of images represented as base64 encoded strings
    public let images: [String]

    public let comments: String
    public let area: String
    public let task: String
    public let tagsString: String

    public let linkedEvent: String?
}
