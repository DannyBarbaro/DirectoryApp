//
//  BlockEmployeeDirectoryTests.swift
//  BlockEmployeeDirectoryTests
//
//  Created by Danny on 2/2/23.
//

import XCTest
import SwiftUI
@testable import BlockEmployeeDirectory

final class BlockEmployeeDirectoryTests: XCTestCase {
    
    // MARK: - Directory View Model Tests
    
    func testFormattedPhoneNumber() throws {
        let vm = DirectoryViewModel()

        let badLengthCase = vm.formattedPhoneNumber("12345")
        XCTAssertEqual(badLengthCase, "12345", "Wrong output when bad length string is passed in")

        let sevenDigitCase = vm.formattedPhoneNumber("1234567")
        XCTAssertEqual(sevenDigitCase, "123-4567", "Seven digit phone number is miss formatted")

        let tenDigitCase = vm.formattedPhoneNumber("1234567890")
        XCTAssertEqual(tenDigitCase, "(123) 456-7890", "Ten digit phone number is miss formatted")

        let elevenDigitCase = vm.formattedPhoneNumber("01234567890")
        XCTAssertEqual(elevenDigitCase, "+0 (123) 456-7890", "Eleven digit phone number is miss formatted")
    }
    
    // MARK: - Image Cache testing
    
    func testImageCahching() async throws {
        let imageCache = ImageCache(networkProvider: MockNetworkProvider())
        
        let imgBadURL = await imageCache.getImage(urlString: "bad")
        XCTAssertEqual(imgBadURL, Image("blank-profile"), "Wrong output when bad url is passed")

        let imgBadData = await imageCache.getImage(urlString: "emptyData")
        XCTAssertEqual(imgBadData, Image("blank-profile"), "Wrong output when bad data is returned from the network")

        let imgData = await imageCache.getImage(urlString: "goodImage")
        XCTAssertNotEqual(imgData, Image("blank-profile"), "Wrong output when good data is returned from the network")
    }
}

struct MockNetworkProvider: NetworkProviding {
    var employeeRequest: String = ""
    
    func fetchDirectoryAt(urlString: String) async throws -> BlockEmployeeDirectory.EmployeeList {
        throw NetworkingErrors.missingData
    }
    
    func fetchImageAt(urlString: String) async throws -> Data {
        if urlString == "bad" {
            throw NetworkingErrors.invalidURL
        } else if urlString == "emptyData" {
            return Data()
        } else {
            // Return good "data" just corrupted data of the blank image
            return UIImage(named: "blank-profile")!.pngData()!
        }
    }
}
