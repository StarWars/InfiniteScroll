import Foundation

protocol CommonDataSourceProtocol {

    var numberOfSections: Int { get }

    func numberOfItems(section: Int) -> Int
    func didSelectItem(at indexPath: IndexPath)

}

extension CommonDataSourceProtocol {
    func didSelectItem(at indexPath: IndexPath) {
        fatalError("The method must be overwritten first")
    }
}
