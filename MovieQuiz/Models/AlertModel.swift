//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 30.05.2024.
//

import Foundation

struct AlertModel {
    let title : String
    let message : String
    let buttonText : String
    let action : () -> Void
}
