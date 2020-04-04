import CocoaLumberjack
import UIKit

protocol BaseWireframeInput: class {

    func close()
    func back()
    func present(_ vc: UIViewController)

}

class BaseWireframe: NSObject {

    weak var currentViewController: UIViewController?

}

extension BaseWireframe: BaseWireframeInput {

    var currentController: UIViewController? {
        return currentViewController
    }

    func back() {
        DispatchQueue.main.async {
            self.currentController?.navigationController?.popViewController(animated: true)
        }
    }

    func close() {
        DispatchQueue.main.async {
            self.currentController?.dismiss(animated: true, completion: nil)
        }
    }

    func present(_ vc: UIViewController) {
        vc.popoverPresentationController?.sourceView = vc.view
        vc.popoverPresentationController?.sourceRect = vc.view.bounds
        vc.popoverPresentationController?.permittedArrowDirections = [.down, .up]

        currentController?.present(vc, animated: true, completion: nil)
    }

}
