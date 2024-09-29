//
//  StringExt.swift
//  BBQuotes17
//
//  Created by Filip Simandl on 26.09.2024.
//

import Foundation

extension String {
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpaces() -> String {
        return self.lowercased().removeSpaces()
    }
}
