import Foundation

protocol MainTabsModuleViewOutput: BasePresenterInput {

}

protocol MainTabsModuleInteractorOutput: class {

}

class MainTabsModulePresenter {

    weak var view: MainTabsModuleViewInput?
    var interactor: MainTabsModuleInteractorInput?
    var wireframe: MainTabsModuleWireframeInput?
    var baseWireframe: BaseWireframeInput? { return wireframe }

}

extension MainTabsModulePresenter: MainTabsModuleViewOutput {

}

extension MainTabsModulePresenter: MainTabsModuleInteractorOutput {

}
