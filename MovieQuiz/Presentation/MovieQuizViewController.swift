import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var indexQuestionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionTextLabel: UILabel!
    
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    private var currentQuestion : QuizQuestion?
    private var questionFactory : QuestionFactoryProtocol?
    private var alertPresenter : AlertPresenter?
    
    private let statisticService : StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.isExclusiveTouch = true
        yesButton.isExclusiveTouch = true
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexQuestionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTextLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        questionFactory.requestNextQuestion()
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
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        lockButtons()
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        lockButtons()
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let textResult = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов : \(statisticService.gamesCount)
                Рекорд : \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность : \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: textResult,
                buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        indexQuestionLabel.text = step.questionNumber
        questionTextLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            action: {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        
        alertPresenter?.showAlert(with: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.unlockButtons()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: (UIImage(named: model.image) ?? UIImage(named: "Default"))!,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func lockButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func unlockButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
}
