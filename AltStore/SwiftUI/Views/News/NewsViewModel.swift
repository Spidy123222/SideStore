//
//  NewsViewModel.swift
//  SideStoreUI
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AltStoreCore

class NewsViewModel: ViewModel {
    
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \NewsItem.date, ascending: false),
        NSSortDescriptor(keyPath: \NewsItem.sortIndex, ascending: true),
        NSSortDescriptor(keyPath: \NewsItem.sourceIdentifier, ascending: true)
    ])
    var news: FetchedResults<NewsItem>
    
    init() {}
}
