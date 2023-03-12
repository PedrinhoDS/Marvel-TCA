import Foundation

public struct MarvelCharacter: Codable, Equatable {
    public let id: Int
    public let name: String
    public let thumbnail: Thumbnail?
    
    public init(id: Int, name: String, thumbnail: Thumbnail? = nil) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}

// MARK: - Thumbnail
public struct Thumbnail: Codable, Equatable {
    public let path: String
    public let thumbnailExtension: String

    public enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    public init(path: String, thumbnailExtension: String) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }
}
