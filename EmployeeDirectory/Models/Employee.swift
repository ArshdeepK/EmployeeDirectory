//
//  Employee.swift
//  EmployeeDirectory
//
//  Created by Arshdeep on 2023-07-11.
//

import UIKit

struct EmployeeResponse: Codable {
     var employees: [Employee]?
}

extension EmployeeResponse {
    enum CodingKeys: String, CodingKey {
        case employees
    }
}

struct Employee: Codable {
    let uuid: String?
    let fullName: String?
    let photoUrl: String?
    let biography: String?
    let team: String?
    let phoneNumber: String?
    let emailAddress: String?

    init (uuid: String?, fullName: String, photoUrl: String?, biography: String?, team: String?, phoneNumber: String?, emailAddress: String?) {
        self.uuid = uuid
        self.fullName = fullName
        self.photoUrl = photoUrl
        self.biography = biography
        self.team = team
        self.phoneNumber = photoUrl
        self.emailAddress = emailAddress
    }
}
