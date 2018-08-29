import UIKit

protocol DashboardModuleWireframeInput: BaseWireframeInput {

}

class DashboardModuleWireframe: BaseWireframe {

    class func setupDashboardModule() -> UIViewController {
        let wireframe = DashboardModuleWireframe()
        let presenter = DashboardModulePresenter()
        let interactor = DashboardModuleInteractor()
        let viewController = DashboardModuleViewController()

        presenter.view = viewController
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        interactor.output = presenter

        wireframe.currentViewController = viewController
        viewController.output = presenter

        return viewController
    }

}

extension DashboardModuleWireframe: DashboardModuleWireframeInput {

}
