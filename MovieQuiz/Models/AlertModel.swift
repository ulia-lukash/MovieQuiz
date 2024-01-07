//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Uliana Lukash on 15.07.2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
