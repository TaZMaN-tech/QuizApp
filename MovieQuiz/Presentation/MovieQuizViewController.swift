import UIKit

final class MovieQuizViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    struct QuizStepViewModel {
        let image: String
        let text: String
        let count: Int
    }
    
    struct QuizResultsViewModel {
        var totalAnswers: Int
        var correctAnswers: Int
        var gamesCount: Int
    }
    
    private var currentQuestionIndex: Int = 0
    
    private var questions: [QuizQuestion] = [QuizQuestion(image: "The Godfather",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "The Dark Knight",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Kill Bill",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "The Avengers",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Deadpool",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "The Green Knight",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Old",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "Tesla",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "Vivarium",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false)]
    
    private var quizResults: QuizResultsViewModel = QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0)


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
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
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
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
            
        }
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(named: step.image)
        textLabel.text = step.text
        counterLabel.text = String(step.count)
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
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
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
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.green.cgColor // делаем рамку белой
        } else {
            imageView.layer.borderColor = UIColor.red.cgColor
        }
        
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            show(quiz: quizResults)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
            show(quiz: convert(model: questions[currentQuestionIndex]))
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
