import CocoaLumberjack
import Foundation

protocol DashboardModuleViewOutput: BasePresenterInput {
    var currentPage: Int { get set }
}

protocol DashboardModuleInteractorOutput: class {

}

class DashboardModulePresenter {

    // MARK: - ivars -
    private var movies = [Movie]()
    private var _currentPage: Int = 1

    // MARK: --
    weak var view: DashboardModuleViewInput?
    var interactor: DashboardModuleInteractorInput?
    var wireframe: DashboardModuleWireframeInput?
    var baseWireframe: BaseWireframeInput? { return wireframe }

    private func retrieveMovies(page: Int) {

        view?.showLoadingIndicator()

        let initialPageQuery = MovieNowPlayingQuery(page: page)

        interactor?.retrieveNowPlayingMovies(query: initialPageQuery) { [weak self] response, error in
            guard let self = self else {
                return
            }

            self.view?.hideLoadingIndicator()

            guard error == nil else {
                self.view?.showStandardAlert(title: nil, message: error!.description)
                return
            }

            guard let response = response else {
                return
            }

            let movies = response.results
            self.movies.append(contentsOf: movies)

            if page < response.totalPages {
                self.currentPage = page + 1
            }

            self.view?.reloadData()

        }
    }
}

extension DashboardModulePresenter: DashboardModuleViewOutput {
    var currentPage: Int {
        get {
            return _currentPage
        }
        set {
            _currentPage = newValue
        }
    }

    func viewDidLoad() {
        retrieveMovies(page: 1)
    }
}

extension DashboardModulePresenter: DashboardModuleInteractorOutput {

}
