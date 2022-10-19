//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 20.09.2022.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    let total: Int
    let date: Date
    
    mutating func compare(newRecord: GameRecord) -> Int {
        if self.correct > newRecord.correct {
            return 1
        } else if self.correct == newRecord.correct {
            return 0
        } else {
            return -1
        }
    }
}
