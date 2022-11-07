import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var resultAlertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?

    private var quizResults = QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0)


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
        resultAlertPresenter = ResultAlertPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }

    func answerButtonClicked(yesAnswer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        var isCorrect = false
        if currentQuestion.correctAnswer == yesAnswer {
            isCorrect = true
            quizResults.correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
        quizResults.totalAnswers += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerButtonClicked(yesAnswer: true)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerButtonClicked(yesAnswer: false)
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = "\(step.count)/10"
    }

    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        // создаём объекты всплывающего окна
        quizResults.gamesCount += 1
        statisticService?.store(correct: quizResults.correctAnswers, total: quizResults.totalAnswers)
        guard let alert = resultAlertPresenter?.show(title: "Этот рануд окончен!", message: statisticService?.getMessage(result: quizResults) ?? "", buttonText: "Сыграть еще раз", onAction: { [self] _ in
            print("OK button is clicked!")
            self.currentQuestionIndex = 0
            self.quizResults.totalAnswers = 0
            self.quizResults.correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }) else { return }
        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // currentQuestionIndex += 1
        let firstStep = QuizStepViewModel(image: (UIImage(data: model.image) ?? UIImage()), text: model.text, count: currentQuestionIndex + 1)
        return firstStep
    }

    private func showAnswerResult(isCorrect: Bool) {
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

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            show(quiz: quizResults)
        } else if currentQuestionIndex < questionsAmount - 1 {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
        } else {
            print("Error")
        }
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки

        guard let model = resultAlertPresenter?.show(title: "Ошибка",
                                               message: message,
                                               buttonText: "Попробовать еще раз",
                                               onAction: { [self] _ in
            print("OK button is clicked!")
            self.currentQuestionIndex = 0
            self.quizResults.totalAnswers = 0
            self.quizResults.correctAnswers = 0
            questionFactory?.requestNextQuestion() }) else { return }

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
