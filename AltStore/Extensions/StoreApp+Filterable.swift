//
//  StoreApp+Searchable.swift
//  SideStore
//
//  Created by Fabian Thies on 01.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import AltStoreCore

extension StoreApp: Filterable {
    func matches(_ searchText: String) -> Bool {
        searchText.isEmpty ||
        self.name.lowercased().contains(searchText.lowercased()) ||
        self.developerName.lowercased().contains(searchText.lowercased())
    }
}
