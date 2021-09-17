//
//  ThumbnailServiceTests.swift
//  MarvelTests
//
//  Created by shuynh on 9/16/21.
//

import XCTest
@testable import Marvel

class ThumbnailServiceTests: XCTestCase {
    func testDownloadThumbnail() {
        let url = URL.init(string: "http://i.annihil.us/u/prod/marvel/i/mg/d/03/58dd080719806.jpg")
        let expectation = XCTestExpectation(description: "Download thumbnail from an url")
        ThumbnailService.shared.downloadThumbnail(url!) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 8.0)
    }
}
