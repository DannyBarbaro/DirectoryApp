//
//  EmployeeTypes.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import Foundation

/// This type is used to decode JSON data received from the server as a named array of Employee Objects
struct EmployeeList: Decodable {
    let employees: [Employee]
}

/// Employee Object as described by JSON Definition listed here https://square.github.io/microsite/mobile-interview-project/
struct Employee: Decodable, Identifiable {
    
    var id: String { uuid }
    
    let uuid: String
    let fullName: String
    let phoneNumber: String?
    let emailAddress: String
    let biography: String?
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let team: String
    let employeeType: EmployeeType
    
    /// Coding keys to decode the JSON provided by the server
    enum CodingKeys: String, CodingKey {
        case uuid, team, biography
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case employeeType = "employee_type"
    }

}

/// Enum describing the employment types provided by the server.
/// This list is exhaustive and we expect no types not listed within this definition
enum EmployeeType: String, Decodable{
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
    
    func description() -> String {
        switch self {
        case .fullTime:
            return "Full Time"
        case .partTime:
            return "Part Time"
        case .contractor:
            return "Contractor"

        }
    }
}
