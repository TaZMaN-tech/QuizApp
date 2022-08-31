import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var quizResults: QuizResultsViewModel = QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0)


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionFactory.requestNextQuestion { [weak self] question in
            guard
                let self = self,
                let question = question
            else {
                // Ошибка
                return
            }
        
        self.currentQuestion = question
            let viewModel = self.convert(model: question)
            DispatchQueue.main.async {
                self.show(quiz: viewModel)
            }
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        var isCorrect = false
        if currentQuestion.correctAnswer == true {
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

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        var isCorrect = false
        if currentQuestion.correctAnswer == false {
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
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(named: step.image)
        textLabel.text = step.text
        counterLabel.text = "\(step.count)/10"
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        // создаём объекты всплывающего окна
        quizResults.gamesCount += 1
        let accuracy = Double(quizResults.correctAnswers) / Double(quizResults.totalAnswers) * 100
        let result = "\(quizResults.correctAnswers)/\(quizResults.totalAnswers)"

        let alert = UIAlertController(title: "Этот рануд окончен!", // заголовок всплывающего окна
                                      message:
                                        """
                                        Ваш результат \(result) \
                                        Количество сыгранных квизов: \(quizResults.gamesCount)
                                        Рекорд: 6/10 (03.07.22)
                                        Средняя точность: \(accuracy)%
                                        """,
                                      // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { [self] _ in
            print("OK button is clicked!")
            self.currentQuestionIndex = 0
            self.quizResults.totalAnswers = 0
            self.quizResults.correctAnswers = 0
            questionFactory.requestNextQuestion { [weak self] question in
                guard
                    let self = self,
                    let question = question
                else {
                    // Ошибка
                    return
                }
            
            self.currentQuestion = question
                let viewModel = self.convert(model: question)
                DispatchQueue.main.async {
                    self.show(quiz: viewModel)
                }
            }
        })

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        //currentQuestionIndex += 1
        let firstStep = QuizStepViewModel(image: model.image, text: model.text, count: currentQuestionIndex + 1)
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
            questionFactory.requestNextQuestion { [weak self] question in
                guard
                    let self = self,
                    let question = question
                else {
                    // Ошибка
                    return
                }
            
            self.currentQuestion = question
                let viewModel = self.convert(model: question)
                DispatchQueue.main.async {
                    self.show(quiz: viewModel)
                }
            }
        } else {
            print("Error")
        }
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
