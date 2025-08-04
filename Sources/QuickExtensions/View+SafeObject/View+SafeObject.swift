//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 16/05/25.
//

import Foundation

extension Array {
    func object(index: Int) -> Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        
        return nil
    }
}
