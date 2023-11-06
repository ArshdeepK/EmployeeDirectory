//
//  NetworkClient.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-13.
//

import Foundation

class NetworkClient {
    private let request: NetworkRequest
    init(request: NetworkRequest = NetworkRequest()) {
        self.request = request
    }

    // Fetch employees API Request
    func fetchEmployees(withListType listType: EmployeeListType,
                        completion: @escaping (Result<EmployeeResponse>) -> Void) {
        let url = {
            switch listType {
            case .all:
                return APIUrl.employeeList.rawValue
            case .malformed:
                return APIUrl.malformedEmployeeList.rawValue
            case .empty:
                return APIUrl.emptyEmployeeList.rawValue
            }
        }()
        request.perform(url: url, completion: completion)
    }
}
