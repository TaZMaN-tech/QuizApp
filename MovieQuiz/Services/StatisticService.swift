//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 20.09.2022.
//

import Foundation


protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    func getMessage(result: QuizResultsViewModel) -> String
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    func getMessage(result: QuizResultsViewModel) -> String {
        let message = """
              Ваш результат \(result.correctAnswers)
              Количество сыгранных квизов: \(gamesCount)
              Рекорд: \(bestGame.correct) \(bestGame.date.dateTimeString)
              Средняя точность: \(String(format: "%.2f", totalAccuracy * 100))%
        """
        return message
    }
    
    private let userDefaults = UserDefaults.standard

    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {
        var newResult = GameRecord(correct: count, total: amount, date: Date())
        if newResult.compare(newRecord: bestGame) > 0 {
            bestGame = newResult
        }
        var newCorrect = newResult.correct + userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(newCorrect, forKey: Keys.correct.rawValue)
        
        var newTotal = newResult.total + userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(newTotal, forKey: Keys.total.rawValue)
        
        gamesCount += 1
    }
    
    var totalAccuracy: Double {
        get {
            Double(userDefaults.integer(forKey: Keys.correct.rawValue)) / Double(userDefaults.integer(forKey: Keys.total.rawValue))
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
}
