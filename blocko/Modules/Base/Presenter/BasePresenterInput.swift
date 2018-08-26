import Foundation

protocol BasePresenterInput: class {

    func backPressed()
    func viewDidLoad()

    var baseWireframe: BaseWireframeInput? { get }

}

extension BasePresenterInput {

    func backPressed() {
        baseWireframe?.back()
    }

    func viewDidLoad() {

    }

    var baseWireframe: BaseWireframeInput? { return nil }

}
