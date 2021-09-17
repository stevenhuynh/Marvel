//
//  ApiServiceTests.swift
//  MarvelTests
//
//  Created by shuynh on 9/16/21.
//

import XCTest
@testable import Marvel

class ApiServiceTests: XCTestCase {
    func testFetchCharacters() {
        let expectation = XCTestExpectation(description: "Fetch characters from Marvel API")
        ApiService.shared.fetchCharacters(0) { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(let error):
                XCTFail("An error occurred when getting characters: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 8.0)
    }
    
    func testFetchCharacterDetails() {
        let expectation = XCTestExpectation(description: "Fetch character details from Marvel API")
        ApiService.shared.fetchCharacterDetails(for: 1011334, section: "comics") { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(let error):
                XCTFail("An error occurred when getting character details: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 8.0)
    }

}
