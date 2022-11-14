//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 14.11.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)

    func showLoadingIndicator()
    func hideLoadingIndicator()

    func showNetworkError(message: String)
}
