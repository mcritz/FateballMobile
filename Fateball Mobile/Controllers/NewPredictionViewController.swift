//
//  NewPredictionViewController.swift
//  Fateball Mobile
//
//  Created by Michael Critz on 6/27/18.
//  Copyright © 2018 Map of the Unexplored. All rights reserved.
//

import UIKit

class NewPredictionViewController: UIViewController, PredictionControllerDelegate {
    @IBOutlet weak var newPredictionDescription: UITextView!
    
    func handle(predictions: [Prediction]) {
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newPrediction = Prediction(description: newPredictionDescription.text, status: .draft)
            do {
                let data = try JSONEncoder().encode(newPrediction)
                try PredictionController(delegate: self).uploadPrediction(data: data)
            } catch {
                print("upload had error")
            }
    }
}
