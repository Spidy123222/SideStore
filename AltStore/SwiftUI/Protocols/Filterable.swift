//
//  Filterable.swift
//  SideStore
//
//  Created by Fabian Thies on 01.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import Foundation

protocol Filterable {
    func matches(_ searchText: String) -> Bool
}

extension Collection where Element: Filterable {
    func matches(_ searchText: String) -> Bool {
        self.contains(where: { $0.matches(searchText) })
    }
    
    func items(matching searchText: String) -> [Element] {
        self.filter { $0.matches(searchText) }
    }
}
