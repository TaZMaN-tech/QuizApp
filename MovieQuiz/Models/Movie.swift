//
//  Movie.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 19.09.2022.
//

import Foundation

struct Actor: Codable {
    let id: String
    let image: String
    let name: String
    let asCharacter: String
}
struct Movie: Codable {
    let id: String
    let title: String
    let year: Int
    let image: String
    let releaseDate: String
    let runtimeMins: Int
    let directors: String
    let actorList: [Actor]

    enum CodingKeys: String, CodingKey {
       case id, title, year, image, runtimeMins, directors, actorList
       case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        
        let year = try container.decode(String.self, forKey: .year)
        self.year = Int(year)!
        
        image = try container.decode(String.self, forKey: .image)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        
        let runtimeMins = try container.decode(String.self, forKey: .runtimeMins)
        self.runtimeMins = Int(runtimeMins)!
        
        directors = try container.decode(String.self, forKey: .directors)
        actorList = try container.decode([Actor].self, forKey: .actorList)
    }
}
