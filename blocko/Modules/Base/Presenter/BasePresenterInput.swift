import CocoaLumberjack
import Foundation
import UIKit

protocol BasePresenterInput: class {
    var baseWireframe: BaseWireframeInput? { get }

    func backPressed()
    func closePressed()
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func present(vc: UIViewController)
}

extension BasePresenterInput {

    func backPressed() {
        baseWireframe?.back()
    }

    func closePressed() {
        baseWireframe?.close()
    }

    func viewDidLoad() {

    }

    func viewWillAppear() {

    }

    func viewWillDisappear() {

    }

    func present(vc: UIViewController) {
        baseWireframe?.present(vc)
    }

}
