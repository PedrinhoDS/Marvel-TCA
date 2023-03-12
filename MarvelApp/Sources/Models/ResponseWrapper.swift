import Foundation

public struct ResponseWrapper<T: Decodable>: Decodable {
    public let code: Int
    public let data: DataContainer<T>
}

// MARK: - CharacterDataContainer
public struct DataContainer<T: Decodable>: Decodable {
    public let offset, limit, total, count: Int
    public let results: [T]
}
