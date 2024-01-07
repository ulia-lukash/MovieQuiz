//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Uliana Lukash on 15.07.2023.
//

import Foundation
import UIKit

class AlertPresenter {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel) {
        
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
            
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}



    
        

        

