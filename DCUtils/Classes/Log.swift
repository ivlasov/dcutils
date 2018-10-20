//
//  DCUtils
//

import Foundation

fileprivate var sharedLog: NSObject?
fileprivate var logExist = true

extension Utils.Log {
    public class Weak {
    
        public func append(event: Utils.Log.Event) {
            if logExist && sharedLog == nil {
                guard let cls = NSClassFromString("LogObjC") as? NSObject.Type else { logExist = false; return }
                sharedLog = cls.self.init()
            }
            sharedLog?.perform(NSSelectorFromString("append:"), with: event)
        }
        
        public static func <<(lhs: Utils.Log.Weak, rhs: Utils.Log.Event) {
            lhs.append(event: rhs)
        }
        
    }
}

extension Utils.Log {
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

extension Utils.Log.Event {
    public convenience init(tag: String? = nil, category: String? = nil, priority: Int = 1000, text: String? = nil, object: Any? = nil) {
        var params = [String:Any]()
        params["text"] = text
        params["object"] = object
        self.init(tag: tag, category: category, priority: priority, parameters: params)
    }
}

extension Utils.Log.Event {
    public convenience init(tag: String? = nil, category: String? = nil, priority: Int = 1000, error: Error) {
        self.init(tag: tag, category: category, priority: priority, parameters: ["error" : error])
    }
}

public enum Logs {
    static let `weak` = Utils.Log.Weak()
}

