//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 05.06.2024.
//

import Foundation

final class StatisticService : StatisticServiceProtocol {
    
    private enum Keys: String {
        case correctAnswers
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
        case quizzesCount
    }
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers : Int {
        get {
            storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    private var quizzesCount : Int {
        get {
            storage.integer(forKey: Keys.quizzesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.quizzesCount.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            if let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                return GameResult(correct: correct, total: total, date: date)
            }
            return GameResult(correct: correct, total: total, date: Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
        
    }
    
    var totalAccuracy: Double {
        get {
            guard gamesCount != 0 else {
                return 0
            }
            return Double(correctAnswers) / (Double(quizzesCount) ) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        quizzesCount += amount
        gamesCount += 1
        if count > bestGame.correct {
            bestGame = GameResult(correct: count, total: amount, date: Date())
        }
    }
}
