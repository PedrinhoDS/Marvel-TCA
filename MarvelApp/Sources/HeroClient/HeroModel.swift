//
//  File.swift
//  
//
//  Created by Pedro Henrique on 3/11/23.
//

import Foundation
import Models

public struct HeroModel: Equatable {
    public let id: Int
    public let name: String
    public let imageUrl: URL?
    public var isFavorite: Bool

    public init(id: Int, isFavorite: Bool, name: String, imageUrl: URL?) {
        self.isFavorite = isFavorite
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
    }
}

extension MarvelCharacter {
    func mapToHeroModel(isFavorite: Bool) -> HeroModel {
        var url: URL?
        if let thumbnail {
            url = URL(string: thumbnail.path.sanitizeURL() + "." + thumbnail.thumbnailExtension)
        }
        
        return HeroModel(
            id: self.id,
            isFavorite: isFavorite,
            name: self.name,
            imageUrl: url
        )
    }
}

public extension Array where Element == HeroModel {
    static var mock: [HeroModel] {
        [
            .spiderMan,
            .ironMan
        ]
    }
}

public extension HeroModel {
    static var spiderMan: HeroModel {
        .init(id: 1, isFavorite: true, name: "Spider Man", imageUrl: URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
    }
    
    static var ironMan: HeroModel {
        .init(id: 2, isFavorite: false, name: "Iron Man", imageUrl: nil)
    }
    
    static var wolverine: HeroModel {
        .init(id: 3, isFavorite: true, name: "Wolwerine", imageUrl: nil)
    }
}
