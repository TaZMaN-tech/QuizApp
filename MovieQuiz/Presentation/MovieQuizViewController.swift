import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var resultAlertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    private var quizResults: QuizResultsViewModel = QuizResultsViewModel(totalAnswers: 0, correctAnswers: 0, gamesCount: 0)


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticServiceImplementation()
        print(NSHomeDirectory())
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsURL)
        let fileName = "text.swift"
       // print(documentsURL)
       // print(NSHomeDirectory())
        documentsURL.appendPathComponent(fileName)
        let hello = "Hello world!"
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            let hello = "Hello world!"
            let data = hello.data(using: .utf8)
            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
        }
        print(documentsURL)
        try? print(String(contentsOf: documentsURL))
        let jsonString = """
            {
                "id": "tt1375666",
                "title": "Inception",
                "year": "2010",
                "image": "https://imdb-api.com/images/original/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_Ratio0.6751_AL_.jpg",
                "releaseDate": "2010-07-16",
                "runtimeMins": "148",
                "directors": "Christopher Nolan",
                "director": {
                        "id": "nm0634240",
                        "name": "Christopher Nolan"
                    },
                "actorList": [
                    {
                        "id": "nm0000138",
                        "image": "https://imdb-api.com/images/original/MV5BMjI0MTg3MzI0M15BMl5BanBnXkFtZTcwMzQyODU2Mw@@._V1_Ratio1.0000_AL_.jpg",
                        "name": "Leonardo DiCaprio",
                        "asCharacter": "Cobb"
                    },
                    {
                        "id": "nm0330687",
                        "image": "https://imdb-api.com/images/original/MV5BMTY3NTk0NDI3Ml5BMl5BanBnXkFtZTgwNDA3NjY0MjE@._V1_Ratio1.0000_AL_.jpg",
                        "name": "Joseph Gordon-Levitt",
                        "asCharacter": "Arthur"
                    },
                    {
                        "id": "nm0680983",
                        "image": "https://imdb-api.com/images/original/MV5BNmNhZmFjM2ItNTlkNi00ZTQ4LTk3NzYtYTgwNTJiMTg4OWQzXkEyXkFqcGdeQXVyMTM1MjAxMDc3._V1_Ratio1.0000_AL_.jpg",
                        "name": "Elliot Page",
                        "asCharacter": "Ariadne"
                    }
                ]
            }
        """
        let data = jsonString.data(using: .utf8)!
        
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
        } 
        
        /*
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(json)
        } catch let error as NSError {
            print("Failed to parse: \(error.localizedDescription)")
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            guard let id = json["id"] as? String,
                    let title = json["title"] as? String,
                    let jsonYear = json["year"] as? String,
                    let year = Int(jsonYear),
                    let image = json["image"] as? String,
                    let releaseDate = json["releaseDate"] as? String,
                    let jsonRuntimeMins = json["runtimeMins"] as? String,
                    let runtimeMins = Int(jsonRuntimeMins),
                    let directors = json["directors"] as? String,
                    let actorList = json["actorList"] as? [Any] else {
                return
            }

            var actors: [Actor] = []

            for actor in actorList {
                guard let actor = actor as? [String: Any],
                        let id = actor["id"] as? String,
                        let image = actor["image"] as? String,
                        let name = actor["name"] as? String,
                        let asCharacter = actor["asCharacter"] as? String else {
                    return
                }
                let mainActor = Actor(id: id,
                                        image: image,
                                        name: name,
                                        asCharacter: asCharacter)
                actors.append(mainActor)
            }
            let movie = Movie(id: id,
                                title: title,
                                year: year,
                                image: image,
                                releaseDate: releaseDate,
                                runtimeMins: runtimeMins,
                                directors: directors,
                                actorList: actors)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")
        } 
        */
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
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
        statisticService?.store(correct: quizResults.correctAnswers, total: quizResults.totalAnswers)
        guard let alert = resultAlertPresenter?.show(message: statisticService?.getMessage(result: quizResults) ?? "", onAction: { [self] _ in
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
            questionFactory?.requestNextQuestion() 
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
