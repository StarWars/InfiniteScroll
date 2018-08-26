import UIKit

protocol BaseWireframeInput: class {

    func close()
    func back()

}

class BaseWireframe: NSObject {

    weak var currentViewController: UIViewController?

}

extension BaseWireframe: BaseWireframeInput {

    var currentController: UIViewController? {
        return currentViewController
    }

}

extension BaseWireframeInput {

    var currentController: UIViewController? {
        return nil
    }

    func back() {
        currentController?.navigationController?.popViewController(animated: true)
    }

    func close() {
        currentController?.dismiss(animated: true, completion: nil)
    }

}
