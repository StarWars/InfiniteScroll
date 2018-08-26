import UIKit

protocol BaseViewInput: class {

    func showStandardAlert(title: String?, message: String?)
    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?)
    func showButtonIndicator(show: Bool)

}

extension BaseViewInput {

    func showStandardAlert(title: String?, message: String?) {}
    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {}
    func showButtonIndicator(show: Bool) {}

}
