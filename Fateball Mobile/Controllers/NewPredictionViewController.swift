//
//  NewPredictionViewController.swift
//  Fateball Mobile
//
//  Created by Michael Critz on 6/27/18.
//  Copyright © 2018 Map of the Unexplored. All rights reserved.
//

import UIKit

class NewPredictionViewController: UIViewController {
    var predictionController: PredictionController?
    @IBOutlet weak var newPredictionDescription: UITextView!
    @IBAction func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction() {
        do {
            let predictionData = try JSONEncoder().encode(Prediction(
                description: newPredictionDescription.text,
                status: .draft
            ))
            try predictionController?.uploadPrediction(data: predictionData)
        } catch {
            print("failed to upload")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newPrediction = Prediction(description: newPredictionDescription.text, status: .draft)
            do {
                let data = try JSONEncoder().encode(newPrediction)
                try predictionController?.uploadPrediction(data: data)
            } catch {
                print("upload had error")
            }
    }
}
