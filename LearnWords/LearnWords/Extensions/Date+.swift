//
//  Date+.swift
//  LearnWords
//
//  Created by sergemi on 15.02.2023.
//

import Foundation

//extension Date {    
//    var millisecondsSince1970: Int64 {
//        return Int64((Float(self.timeIntervalSince1970) * 1000.0).rounded())
//    }
//}

extension Date {
    func daysFromToday() -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var formattedNow: String {
        let df = DateFormatter.get("yyyy-MM-dd HH:mm:ss")
        let today = Date()
        return df.string(from: today)
    }

    func toString(dateFormat format: String = "yyyy-MM-dd", inUTC: Bool = false) -> String {
        let dateFormatter = DateFormatter.get(format)
        if inUTC {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        }
        else {
            dateFormatter.timeZone = TimeZone.current
        }

        return dateFormatter.string(from: self)
    }
    
    func toServer() -> String {
        var ret = ""
        
        ret = toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss", inUTC: true)
        
        return ret
    }
}

func isSameDay(_ first: Date?, _ second: Date?) -> Bool {
    if first == nil || second == nil {
        return false
    }
    
    return Calendar.current.isDate(first!, inSameDayAs: second!)
}
