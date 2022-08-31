//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 24.08.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion(completion: (QuizQuestion?) -> Void)
}
