//
//  DCUtils
//

import Foundation

extension Date: TransformableType {
    public static let transformableType = "Date"
}
extension Date: AsDouble {}

extension Date {
    public func string(
        format: String,
        locale: Locale = Localization.current.locale,
        timeZone: TimeZone = TimeZone.current,
        calendar: Calendar = Calendar.default
    ) -> String? {
        let df = DateFormatter()
        df.dateFormat = format
        df.locale = locale
        df.timeZone = timeZone
        df.calendar = calendar
        return df.string(from: self)
    }
}

extension Date {
    public func string(
        date: DateFormatter.Style = .medium,
        time: DateFormatter.Style = .none,
        locale: Locale = Localization.current.locale,
        timeZone: TimeZone = TimeZone.current,
        calendar: Calendar = Calendar.default
    ) -> String? {
        let df = DateFormatter()
        df.dateStyle = date
        df.timeStyle = time
        df.timeZone = timeZone
        df.locale = locale
        df.calendar = calendar
        return df.string(from: self)
    }
}


extension String {
    public func date(
        format: String,
        locale: Locale = Localization.current.locale,
        timeZone: TimeZone = TimeZone.current,
        calendar: Calendar = Calendar.default
    ) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        df.locale = locale
        df.timeZone = timeZone
        df.calendar = calendar
        return df.date(from: self)
    }
}

extension Calendar {
    public static var `default`: Calendar { return Localization.current.locale.calendar }
}

extension Date {
    public func era(calendar: Calendar = .default) -> Int               { return calendar.component(.era, from: self) }
    public func year(calendar: Calendar = .default) -> Int              { return calendar.component(.year, from: self) }
    public func month(calendar: Calendar = .default) -> Int             { return calendar.component(.month, from: self) }
    public func day(calendar: Calendar = .default) -> Int               { return calendar.component(.day, from: self) }
    public func hour(calendar: Calendar = .default) -> Int              { return calendar.component(.hour, from: self) }
    public func minute(calendar: Calendar = .default) -> Int            { return calendar.component(.minute, from: self) }
    public func second(calendar: Calendar = .default) -> Int            { return calendar.component(.second, from: self) }
    public func weekday(calendar: Calendar = .default) -> Int           { return calendar.component(.weekday, from: self) }
    public func weekdayOrdinal(calendar: Calendar = .default) -> Int    { return calendar.component(.weekdayOrdinal, from: self) }
    public func quarter(calendar: Calendar = .default) -> Int           { return calendar.component(.quarter, from: self) }
    public func weekOfMonth(calendar: Calendar = .default) -> Int       { return calendar.component(.weekOfMonth, from: self) }
    public func weekOfYear(calendar: Calendar = .default) -> Int        { return calendar.component(.weekOfYear, from: self) }
    public func yearForWeekOfYear(calendar: Calendar = .default) -> Int { return calendar.component(.weekday, from: self) }
    public func nanosecond(calendar: Calendar = .default) -> Int        { return calendar.component(.nanosecond, from: self) }
}

extension Date {
    public init?(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, calendar: Calendar = .default) {
        var comps = DateComponents()
        comps.day = day
        comps.year = year
        comps.month = month
        comps.hour = hour
        comps.minute = minute
        comps.second = second
        if let date = calendar.date(from: comps) { self.init(timeIntervalSince1970: date.timeIntervalSince1970) }
        return nil
    }
}
