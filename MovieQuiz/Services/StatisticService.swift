//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 05.06.2024.
//

import Foundation

final class StatisticService : StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            UserDefaults.standard.integer(forKey: "games_count")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "games_count")
        }
    }
    
    var bestGame: GameResult {
        
    }
    
    var totalAccuracy: Double {
        
    }
    
    func store(correct count: Int, total amount: Int) {
        <#code#>
    }
    
    
}
