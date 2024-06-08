//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Никита Анохин on 30.05.2024.
//

import UIKit

final class AlertPresenter {
    weak var delegate : UIViewController?
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.action()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
