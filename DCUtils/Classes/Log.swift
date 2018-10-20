//
//  DCUtils
//

import Foundation

fileprivate var sharedLog: NSObject?
fileprivate var logExist = true

public enum Log {}

extension Log {
    public class Default {
        static let shared = Log.Default()
        fileprivate init() {}
    }
}

extension Log {
    public class Weak {
        
        static let shared = Log.Weak()
        
        fileprivate init() {}
    
        public func append(event: Log.Event) {
            if logExist && sharedLog == nil {
                guard let cls = NSClassFromString("LogObjC") as? NSObject.Type else { logExist = false; return }
                sharedLog = cls.self.init()
            }
            sharedLog?.perform(NSSelectorFromString("append:"), with: event)
        }
        
        public static func <<(lhs: Log.Weak, rhs: Log.Event) {
            lhs.append(event: rhs)
        }
        
    }
}

extension Log {
    public class Event {
        let tag         : String?
        let category    : String?
        let priority    : Int
        let parameters  : [String:Any]?
        
        public init(tag: String? = nil, category: String? = nil, priority: Int = 1000, parameters: [String:Any]?) {
            self.tag        = tag
            self.category   = category
            self.priority   = priority
            self.parameters = parameters
        }
        
    }
}

extension Log.Event {
    public convenience init(tag: String? = nil, category: String? = nil, priority: Int = 1000, text: String? = nil, object: Any? = nil) {
        var params = [String:Any]()
        params["text"] = text
        params["object"] = object
        self.init(tag: tag, category: category, priority: priority, parameters: params)
    }
}

extension Log.Event {
    public convenience init(tag: String? = nil, category: String? = nil, priority: Int = 1000, error: Error) {
        self.init(tag: tag, category: category, priority: priority, parameters: ["error" : error])
    }
}

func Logs() -> Log.Default {
    return Log.Default.shared
}

func LogsWeak() -> Log.Weak {
    return Log.Weak.shared
}
