//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 07.09.2022.
//

import UIKit

class ResultAlertPresenter: UIViewController, AlertPresenterProtocol {
    func show(title: String, message: String, buttonText: String, onAction: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, // заголовок всплывающего окна
                                      message: message, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: buttonText, style: .default, handler: onAction)

        // добавляем в алерт кнопки
        alert.addAction(action)

        return alert
    }
}
