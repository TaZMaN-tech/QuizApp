//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 03.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
