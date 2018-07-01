//
//  PredictionClientController.swift
//  Fateball Mobile
//
//  Created by Michael Critz on 6/23/18.
//  Copyright © 2018 Map of the Unexplored. All rights reserved.
//

import Foundation

protocol PredictionControllerDelegate {
    func handle(predictions: [Prediction])
}

class PredictionController {
    init(delegate: PredictionControllerDelegate) {
        self.delegate = delegate
    }
    var delegate: PredictionControllerDelegate
    var predictions: [Prediction]?
    func handleError(error: Error) {
        print(error)
    }
    func uploadPrediction(data: Data, completionHandler: @escaping () -> Void) throws {
        let maybeUrl = URL(string: "http://localhost:8080/predictions")
        guard let url: URL = maybeUrl else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    completionHandler()
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                completionHandler()
                print ("got data: \(dataString)")
                return
            }
        }
        task.resume()
    }
    func startLoad() throws {
        let maybeUrl = URL(string: "http://localhost:8080/predictions")
        guard let url: URL = maybeUrl else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                self.handleError(error: error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
//                    self.handleError(error: response, isServer: true)
                    print(response.debugDescription)
                    return
            }
            if let mimeType = httpResponse.mimeType,
                mimeType == "application/json",
                let data = data
//                , let string = String(data: data, encoding: .utf8)
            {
//                    print(string)
                    let decoder = JSONDecoder()
                    do {
                        self.predictions = try decoder.decode([Prediction].self, from: data)
                        if let realPredix: [Prediction] = self.predictions {
                            self.delegate.handle(predictions: realPredix)
                        }
                    } catch {
                        return
                    }
//                    DispatchQueue.main.async {
                        // self.webView.loadHTMLString(string, baseURL: url)
//                    }
            }
        }
        task.resume()
    }
}
