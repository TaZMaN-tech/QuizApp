//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 03.09.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
