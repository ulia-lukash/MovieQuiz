//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Uliana Lukash on 11.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService!
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
            statisticService = StatisticServiceImplementation()
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
            
        }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked(_ sender: Any) {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked(_ sender: Any) {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        let givenAnswer = isYes
            
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        let viewModel = self.convert(model: question)
        self.currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        self.viewController?.yesButton.isEnabled = true
        self.viewController?.noButton.isEnabled = true
    }
    
        func showNextQuestionOrResults() {
            if self.isLastQuestion() {
                statisticService?.store(correct: correctAnswers, total: questionsAmount)
                viewController?.showAlert()
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        self.correctAnswers = 0
        self.resetQuestionIndex()
        questionFactory?.requestNextQuestion()
    }
    
    func makeResultMessage() -> String {
        
        guard let service = statisticService, let bestGame = statisticService?.bestGame else {
            assertionFailure("error")
            return ""
        }
        let totalGamesPlayed = "Кол-во сыгранных игр: \(String(service.gamesCount))"
        let currentGameResult = "Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)"
        let bestGameInfo = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Средняя точность: \(String(format: "%.2f", service.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResult, totalGamesPlayed, bestGameInfo, averageAccuracy].joined(separator: "\n")
        return resultMessage
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
                
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
}
