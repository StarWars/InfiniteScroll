import Foundation

protocol MainTabsModuleInteractorInput: BaseInteractorInput {

}

class MainTabsModuleInteractor {

    weak var output: MainTabsModuleInteractorOutput?

}

extension MainTabsModuleInteractor: MainTabsModuleInteractorInput {

}
