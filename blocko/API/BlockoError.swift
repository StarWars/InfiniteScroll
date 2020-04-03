import UIKit

class BlockoError: NSError {

    private(set) var message: String?
    private(set) var errorCode: Int?
    private(set) var errorsDict: [String: AnyObject]?

    convenience init(message: String?, code: Int? = nil, errorsDict: [String: AnyObject]? = nil) {
        self.init(domain: "pl.appbeat.blocko", code: 0, userInfo: nil)
        self.message = message
        errorCode = code
        self.errorsDict = errorsDict
    }

}
