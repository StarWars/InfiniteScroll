import UIKit

protocol MainTabsModuleWireframeInput: BaseWireframeInput {

}

class MainTabsModuleWireframe: BaseWireframe {

    class func setupMainTabsModule() -> UIViewController {
        let wireframe = MainTabsModuleWireframe()
        let presenter = MainTabsModulePresenter()
        let interactor = MainTabsModuleInteractor()
        let viewController = MainTabsModuleViewController()

        presenter.view = viewController
        presenter.wireframe = wireframe
        presenter.interactor = interactor

        interactor.output = presenter

        wireframe.currentViewController = viewController
        viewController.output = presenter

        let navController = NavigationController(rootViewController: viewController)

        return navController
    }

}

extension MainTabsModuleWireframe: MainTabsModuleWireframeInput {

}
