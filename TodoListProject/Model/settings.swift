//
//  File.swift
//  TodoListProject
//
//  Created by Jakob Michaelsen on 10/03/2024.
//

import Foundation


struct StringFormat {
   static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "EEEE, d MMM, y"
        return df
    }
    
    func stringInToday(date: String) -> Bool {
        let stringToDate = StringFormat.dateFormatter.date(from: date) ?? Date()
        return Calendar.current.isDateInToday(stringToDate)
    }
}

enum RepeatOptions: String, CaseIterable {
    case never = "never"
    case daily = "every day"
    case weekly = "every week"
    case monthly = "every month"
}

