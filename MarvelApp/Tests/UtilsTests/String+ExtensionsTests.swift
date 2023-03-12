//
//  String+ExtensionsTests.swift
//  
//
//  Created by Pedro Henrique on 3/11/23.
//

import XCTest

@testable import Utils

final class String_ExtensionsTests: XCTestCase {

    func testSanitizeString() {
        let str = "http://string.com".sanitizeURL()
        XCTAssertEqual("https://string.com", str)
    }
    
    func testSanitizeValidString() {
        let str = "https://string.com".sanitizeURL()
        XCTAssertEqual("https://string.com", str)
    }
}
