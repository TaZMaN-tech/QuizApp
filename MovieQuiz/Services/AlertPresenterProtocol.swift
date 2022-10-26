//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Тадевос Курдоглян on 07.09.2022.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(message: String, onAction: @escaping (UIAlertAction) -> Void) -> UIAlertController
}
