//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 14.11.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    private var questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?

    var statisticService: StatisticServiceImplementation?
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController as? MovieQuizViewController

        statisticService = StatisticServiceImplementation()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }

    func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }


    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let firstStep = QuizStepViewModel(image: (UIImage(data: model.image) ?? UIImage()), text: model.text, count: currentQuestionIndex + 1)
        return firstStep
    }

    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
    }

    func switchToNextQuestion() {
            currentQuestionIndex += 1
    }

    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }

    func yesButtonClicked() {
        viewController?.answerButtonClicked(yesAnswer: true)
    }

    func noButtonClicked() {
        viewController?.answerButtonClicked(yesAnswer: false)
    }

    func answerButtonClicked(yesAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        var isCorrect = false
        if currentQuestion.correctAnswer == yesAnswer {
            isCorrect = true
            viewController?.quizResults.correctAnswers += 1
        }
        viewController?.showAnswerResult(isCorrect: isCorrect)
        viewController?.quizResults.totalAnswers += 1
    }

    func showNextQuestionOrResults() {
        if self.isLastQuestion() { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            viewController?.show(quiz: viewController?.quizResults ?? QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0))
        } else {
            self.switchToNextQuestion() // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        }
    }

    func proceedAnswer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewController?.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.viewController?.yesButton.isEnabled = true
            self.viewController?.noButton.isEnabled = true
        }
    }
}
