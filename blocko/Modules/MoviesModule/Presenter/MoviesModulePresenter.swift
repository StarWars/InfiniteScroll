import CocoaLumberjack
import Foundation

protocol MoviesModulePresenterInput: BasePresenterInput {

    var retrievedMovies: [Movie] { get }

    func movie(at indexPath: IndexPath) -> Movie?
    func showMovieDetails(at indexPath: IndexPath)

}

protocol MoviesModuleInteractorOutput: class {

}

class MoviesModulePresenter {

    private var movies = [Movie]()
    private var currentPage = 1

    weak var view: MoviesModuleViewInput?
    let interactor: MoviesModuleInteractorInput
    let wireframe: MoviesModuleWireframeInput

    init(interactor: MoviesModuleInteractorInput,
         wireframe: MoviesModuleWireframeInput) {
        self.interactor = interactor
        self.wireframe = wireframe
    }

    func viewDidLoad() {
        retrieveMovies(page: currentPage)
    }

    private func retrieveMovies(page: Int) {

        view?.showLoadingIndicator()

        let initialPageQuery = MovieNowPlayingQuery(page: page)

        interactor.retrieveNowPlayingMovies(query: initialPageQuery) { [weak self] response, error in
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

extension MoviesModulePresenter: MoviesModulePresenterInput {

    var retrievedMovies: [Movie] {
        return movies
    }

    var baseWireframe: BaseWireframeInput? {
        return wireframe
    }

    func movie(at indexPath: IndexPath) -> Movie? {
        guard indexPath.row < movies.count else {
            DDLogError("invalid index path item requested")
            return nil
        }
        return movies[indexPath.row]
    }

    func showMovieDetails(at indexPath: IndexPath) {
        guard let movieToShow = movie(at: indexPath) else {
            view?.showStandardAlert(title: R.string.localizable.error_failure(), message: "Movie not found")
            return
        }
        wireframe.showDetails(of: movieToShow)
    }
    
}

extension MoviesModulePresenter: MoviesModuleInteractorOutput {

}
