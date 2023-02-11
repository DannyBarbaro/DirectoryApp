//
//  DirectoryViewModel.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import Foundation
import SwiftUI

class DirectoryViewModel: ObservableObject {
    
    @Published private(set) var employeeList: EmployeeList?
    private let networkProvider: NetworkProviding
    private let imageCache: ImageCaching

    /// Inject the NetworkingProvider and ImageCache to create the directory view model
    init(networkProvider: NetworkProviding = NetworkProvider()) {
        self.networkProvider = networkProvider
        self.imageCache = ImageCache(networkProvider: networkProvider)
    }
    
    /// Get the directory data from the server via the networking provider
    func refresh() {
        Task {
            do {
                let list = try await networkProvider.fetchDirectoryAt(urlString: networkProvider.employeeRequest)
                await MainActor.run {
                    employeeList = list
                }
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
    
    /// Returns an image form the image cache and caches it if needed
    func getImage(urlString: String) async -> Image {
        return await imageCache.getImage(urlString: urlString)
    }
    
    /// Returns a formatted version of a phone number
    func formattedPhoneNumber(_ number: String) -> String
    {
        if number.count == 7 {
            return "\(number.prefix(3))-\(number.suffix(4))"
        } else if number.count == 10 {
            let middleThreeStart = number.index(number.startIndex, offsetBy: 3)
            let middleThreeEnd = number.index(number.startIndex, offsetBy: 6)
            let range = middleThreeStart..<middleThreeEnd
            return "(\(number.prefix(3))) \(number[range])-\(number.suffix(4))"
        } else if number.count == 11 {
            let areaCodeStart = number.index(number.startIndex, offsetBy: 1)
            let areaCodeEnd = number.index(number.startIndex, offsetBy: 4)
            let areaCodeRange = areaCodeStart..<areaCodeEnd
            let middleThreeStart = number.index(number.startIndex, offsetBy: 4)
            let middleThreeEnd = number.index(number.startIndex, offsetBy: 7)
            let middleThreeRange = middleThreeStart..<middleThreeEnd
            return "+\(number.prefix(1)) (\(number[areaCodeRange])) \(number[middleThreeRange])-\(number.suffix(4))"
        } else {
            return number
        }
    }
}
