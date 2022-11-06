//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 07.09.2022.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(title: String, message: String, buttonText: String, onAction: @escaping (UIAlertAction) -> Void) -> UIAlertController
}
