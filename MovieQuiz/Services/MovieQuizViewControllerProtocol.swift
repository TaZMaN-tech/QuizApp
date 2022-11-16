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
    func hideActivityIndicator()
    func hideBorder()
    func answerButtonClicked(yesAnswer: Bool)
    func enableButtons()

    func showAnswerResult(isCorrect: Bool)

    func showNetworkError(message: String)
}
