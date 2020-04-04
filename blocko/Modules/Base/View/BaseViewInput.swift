import CocoaLumberjack
import UIKit

protocol BaseViewInput: class {

    func showStandardAlert(title: String?, message: String?)
    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?)
    func showButtonIndicator(show: Bool)

}

extension BaseViewInput {

    func showStandardAlert(title: String?, message: String?) {
        DDLogVerbose("Not implemented")
    }
    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {
        DDLogVerbose("Not implemented")
    }
    func showButtonIndicator(show: Bool) {
        DDLogVerbose("Not implemented")
    }

}
