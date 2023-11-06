//
//  Request.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-11.
//

import Foundation

enum APIUrl: String {
    case employeeList = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    case malformedEmployeeList = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    case emptyEmployeeList = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
}

enum HTTPMethod: String {
    case GET = "GET"
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class NetworkRequest {
    func perform<T: Decodable>(for: T.Type = T.self, url: String, parameters: [String: Any]? = nil, method: HTTPMethod = .GET, completion: @escaping (Result<T>) -> Void) {
        // Create a custom URL session configuration
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData // Ignore local cache

        // Create a URL session with the custom configuration
        let session = URLSession(configuration: config)
            guard let url = URL(string: url) else { return }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            if let parameters {
                do {
                    let json = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    urlRequest.httpBody = json
                } catch let error {
                    completion(.failure(error))
                }
            }
            let task = session.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        // Convert the parameter from snake case to camel case. Eg: `full_name` to `fullName`
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        let json = try decoder.decode(T.self, from: data)
                        completion(.success(json))
                    } catch let error {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "Undefined Error", code: -1)))
                }
            }
            task.resume()
    }
}
