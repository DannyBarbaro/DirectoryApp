//
//  NetworkingManager.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import Foundation

/// Networking Providing protocol to allow mocking for data in testing
protocol NetworkProviding {
    var employeeRequest: String { get }
    func fetchDirectoryAt(urlString: String) async throws -> EmployeeList
    func fetchImageAt(urlString: String) async throws -> Data
}

struct NetworkProvider: NetworkProviding {
    
    let employeeRequest = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    /// Testing end points
//    let malformedEmployeeRequestURL = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
//    let emptyEmployeeRequestURL = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
    
    /// Gets full directory data from the server
    func fetchDirectoryAt(urlString: String) async throws -> EmployeeList {
        guard let url = URL(string: urlString) else {
            throw NetworkingErrors.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let parseResults = try JSONDecoder().decode(EmployeeList.self, from: data)
        return parseResults
    }
    
    /// Gets the data for the image at a given url
    func fetchImageAt(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkingErrors.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
}

/// Assorted Errors for network handling
enum NetworkingErrors: Error {
    case invalidURL
    case missingData
}
