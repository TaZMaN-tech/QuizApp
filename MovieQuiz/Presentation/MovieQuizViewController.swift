import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var resultAlertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!

    var quizResults = QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0)


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        resultAlertPresenter = ResultAlertPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func answerButtonClicked(yesAnswer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter.answerButtonClicked(yesAnswer: yesAnswer)
        presenter.proceedAnswer()
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = "\(step.count)/10"
    }

    func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        // создаём объекты всплывающего окна
        quizResults.gamesCount += 1
        presenter.statisticService?.store(correct: quizResults.correctAnswers, total: quizResults.totalAnswers)
        guard let alert = resultAlertPresenter?.show(title: "Этот раунд окончен!", message: presenter.statisticService?.getMessage(result: quizResults) ?? "", buttonText: "Сыграть ещё раз", onAction: { [self] _ in
            print("OK button is clicked!")
            self.presenter.resetQuestionIndex()
            self.quizResults.totalAnswers = 0
            self.quizResults.correctAnswers = 0
            self.presenter.restartGame()
        }) else { return }
        alert.view.accessibilityIdentifier = "Game results"
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

    func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect == true {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor // делаем рамку белой
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }

        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    internal func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки

        guard let model = resultAlertPresenter?.show(title: "Ошибка",
                                               message: message,
                                               buttonText: "Попробовать еще раз",
                                               onAction: { [self] _ in
            print("OK button is clicked!")
            self.presenter.resetQuestionIndex()
            self.quizResults.totalAnswers = 0
            self.quizResults.correctAnswers = 0
            self.presenter.restartGame() }) else { return }

        // показываем всплывающее окно
        self.present(model, animated: true, completion: nil)
    }
    /*
     Mock-данные
     
     
     Картинка: The Godfather
     Настоящий рейтинг: 9,2
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Dark Knight
     Настоящий рейтинг: 9
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Kill Bill
     Настоящий рейтинг: 8,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Avengers
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Deadpool
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Green Knight
     Настоящий рейтинг: 6,6
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Old
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: The Ice Age Adventures of Buck Wild
     Настоящий рейтинг: 4,3
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Tesla
     Настоящий рейтинг: 5,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Vivarium
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     */
}
