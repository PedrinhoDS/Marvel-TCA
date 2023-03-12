//
//  File.swift
//  
//
//  Created by Pedro Henrique on 3/11/23.
//

import Foundation

public extension String {
    func sanitizeURL() -> String {
        if self.hasPrefix("http://") {
            return self.replacingOccurrences(of: "http://", with: "https://")
        }
        return self
    }
}
