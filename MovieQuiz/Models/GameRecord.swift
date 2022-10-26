//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 20.09.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }

    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct == rhs.correct
    }

    var correct: Int
    let total: Int
    let date: Date
}
