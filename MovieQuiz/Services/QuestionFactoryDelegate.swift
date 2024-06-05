//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 30.05.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
