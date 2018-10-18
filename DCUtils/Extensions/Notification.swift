//
//  DCUtils
//

import Foundation

extension Notification {
    
    static let queue = OperationQueue()
    
    public static func subscribe(observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    public static func subscribe(name: NSNotification.Name, object: AnyObject? = nil, queue: OperationQueue? = nil, _ handler: @escaping ((Notification) -> Void)) {
        NotificationCenter.default.addObserver(forName: name, object: object, queue: queue ?? Notification.queue) { (ntf) in
            if queue == Notification.queue {
                handler(ntf)
            } else {
                OperationQueue.main.addOperation {
                    handler(ntf)
                }
            }
        }
    }
    
    public static func unsubscribe(observer: AnyObject, name: NSNotification.Name? = nil, object: AnyObject? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }
    
    public static func post(name: NSNotification.Name, object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
}
