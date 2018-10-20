//
//  DCUtils
//

import Foundation

fileprivate var sharedLog: NSObject?
fileprivate var logExist = true

public enum Log {}

extension Log {
    
    public static func weak(tag: String? = nil, category: String, priority: Int = 1000, parameters: [String:Any]?) {
        if logExist && sharedLog == nil {
            guard let cls = NSClassFromString("LogObjC") as? NSObject.Type else { logExist = false; return }
            sharedLog = cls.self.init()
        }
        var record = [String:Any]()
        record["tag"] = tag
        record["category"] = category
        record["priority"] = priority
        record["parameters"] = parameters
        sharedLog?.perform(NSSelectorFromString("append:"), with: record)
    }
    
}
