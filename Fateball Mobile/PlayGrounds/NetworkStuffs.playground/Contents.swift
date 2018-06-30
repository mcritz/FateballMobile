//: Playground - noun: a place where people can play

import UIKit
let url = URL(string: "http://localhost/predictions")!
let request = URLRequest(url: url)

var data: Data?
var response: URLResponse?
var error: Error?

let task = URLSession.shared.dataTask(with: request) { dda, res, err in
    data = dda
    response = res
    error = err
}
task.resume()

data
response
error
