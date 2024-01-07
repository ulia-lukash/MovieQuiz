//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Uliana Lukash on 20.07.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
}
