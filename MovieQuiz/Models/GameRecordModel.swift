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
    
    static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy > lhs.accuracy
    }
    func compareResults(previousRecord: GameRecord) -> Bool {
        return self.correct > previousRecord.correct ? true : false
    }
}
