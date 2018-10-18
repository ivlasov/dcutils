//
//  DCUtils
//

import Foundation

extension Date {
    
    public func string(format: String) -> String? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
}

extension Date {
    
    public init(day: Int, month: Int, year: Int) {
        var comps = DateComponents()
        comps.day = day
        comps.year = year
        comps.month = month
        if let date = NSCalendar.current.date(from: comps) {
            self.init(timeIntervalSince1970: date.timeIntervalSince1970)
        } else {
            self.init()
        }
    }
    
    public var month    : Int { return Calendar.current.component(.month, from: self) }
    public var year     : Int { return Calendar.current.component(.year, from: self) }
    
    public func string(style: DateFormatter.Style) -> String {
        let df = DateFormatter()
        df.dateStyle = style
        return df.string(from: self)
    }
    
}
