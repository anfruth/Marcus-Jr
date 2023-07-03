//
//  MeditationDatesViewModel.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/2/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation

final class MeditationDatesViewModel: ObservableObject {
    
    @Published var datesToDisplay: [String]
    private var dates = [Date]()
    
    init(dates: [Date]) {
        self.dates = dates
        datesToDisplay = []
        
        datesToDisplay = formattedDates
    }
    
    // inefficient way of maintaining sorted list, but list will be too small to matter.
    private var formattedDates: [String] {
        return dates.sorted().map {
            return DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .short)
        }
    }
    
    func insert(date: Date) {
        if dates.contains(date) { return }
        dates.append(date)
        datesToDisplay = formattedDates
    }
    
    func delete(indexSet: IndexSet) {
        dates.remove(atOffsets: indexSet)
        datesToDisplay = formattedDates
    }
}
