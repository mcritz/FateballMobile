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
            try predictionController?.uploadPrediction(data: predictionData, completionHandler: {
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            })
//            self.navigationController?.popViewController(animated: true)
        } catch {
            print("fa/Users/mcritz/Developer/fateball/Fateball Mobile/Fateball Mobile/Base.lproj/Main.storyboard: “Tab Bar Controller“ is unreachable because it has no entry points, and no identifier for runtime access via -[UIStoryboard instantiateViewControllerWithIdentifier:].iled to upload")
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Could not upload", comment: "Could not upload"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
    private func handleSuccess() {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
