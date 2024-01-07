//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Uliana Lukash on 16.07.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var correct: Double {
        get {
            userDefaults.double(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        return (correct/total)*100
    }
    
    var bestGame: GameRecord? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let bestGame = try? decoder.decode(GameRecord.self, from: data) else {
                return nil
            }
            return bestGame
        }
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += Double(count)
        self.total += Double(amount)
        self.gamesCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if let previousBestGame = bestGame {
            if currentGame > previousBestGame {
                bestGame = currentGame
            }
        } else {
            bestGame = currentGame
        }
    }
}



