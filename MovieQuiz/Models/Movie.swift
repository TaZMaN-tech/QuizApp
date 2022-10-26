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
}
