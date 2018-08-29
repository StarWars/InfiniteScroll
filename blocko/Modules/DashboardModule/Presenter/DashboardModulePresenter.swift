import Foundation

protocol DashboardModuleViewOutput: BasePresenterInput {

}

protocol DashboardModuleInteractorOutput: class {

}

class DashboardModulePresenter {

    weak var view: DashboardModuleViewInput?
    var interactor: DashboardModuleInteractorInput?
    var wireframe: DashboardModuleWireframeInput?
    var baseWireframe: BaseWireframeInput? { return wireframe }

}

extension DashboardModulePresenter: DashboardModuleViewOutput {

}

extension DashboardModulePresenter: DashboardModuleInteractorOutput {

}
