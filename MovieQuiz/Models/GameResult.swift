//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 05.06.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    static func >(left: GameResult, right: GameResult) -> Bool {
        return left.correct > right.correct
    }
}
