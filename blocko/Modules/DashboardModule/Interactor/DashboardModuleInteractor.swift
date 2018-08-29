import Foundation

protocol DashboardModuleInteractorInput: BaseInteractorInput {

}

class DashboardModuleInteractor {

    weak var output: DashboardModuleInteractorOutput?

}

extension DashboardModuleInteractor: DashboardModuleInteractorInput {

}
