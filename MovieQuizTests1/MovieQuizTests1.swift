//
//  MovieQuizTests1.swift
//  MovieQuizTests1
//
//  Created by Тадевос Курдоглян on 14.11.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func hideActivityIndicator() {
    }

    func hideBorder() {
    }

    func answerButtonClicked(yesAnswer: Bool) {
    }

    func enableButtons() {
    }

    func showAnswerResult(isCorrect: Bool) {
    }

    func show(quiz step: QuizStepViewModel) {
    }

    func show(quiz result: QuizResultsViewModel) {
    }
    func showLoadingIndicator() {
    }

    func hideLoadingIndicator() {
    }

    func showNetworkError(message: String) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.text, "Question Text")
        XCTAssertEqual(viewModel.count, 1)
    }
}
