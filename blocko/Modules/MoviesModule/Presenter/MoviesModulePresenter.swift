import CocoaLumberjack
import Foundation

protocol MoviesModulePresenterInput: BasePresenterInput {

    var retrievedMovies: [Movie] { get }
    var totalMoviesCount: Int { get }

    func movie(at indexPath: IndexPath) -> Movie?
    func showMovieDetails(at indexPath: IndexPath)
    func retrieveMovies()
    func toggleFavourite(_ movie: Movie)
}

protocol MoviesModuleInteractorOutput: class {

}

class MoviesModulePresenter {

    private var movies = [Movie]()
    private var currentPage = 1
    private var totalCount = 0

    weak var view: MoviesModuleViewInput?
    let interactor: MoviesModuleInteractorInput
    let wireframe: MoviesModuleWireframeInput

    init(interactor: MoviesModuleInteractorInput,
         wireframe: MoviesModuleWireframeInput) {
        self.interactor = interactor
        self.wireframe = wireframe
    }

    func viewDidLoad() {
        retrieveMovies()
    }


    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

extension MoviesModulePresenter: MoviesModulePresenterInput {

    var totalMoviesCount: Int {
        return totalCount
    }

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

    func toggleFavourite(_ movie: Movie) {
        DataController.shared.toggle(movie: movie)
    }

    func retrieveMovies() {

        let initialPageQuery = MovieNowPlayingQuery(page: currentPage)

        interactor.retrieveNowPlayingMovies(query: initialPageQuery) { [weak self] response, error in
            guard let self = self else {
                return
            }

            self.view?.stopPullToRefreshAnimation()

            if let response = response  {

                self.movies.append(contentsOf: response.results)

                /**
                 It seems that for page `1`, totalResults is different than for page `2` and later
                 Reload to prevent the crash.
                 */
                if self.totalCount != response.totalResults {
                    self.view?.reloadData(newIndexPathsToReload: nil)
                }

                self.totalCount = response.totalResults
                self.currentPage += 1

                if response.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.results)
                    self.view?.reloadData(newIndexPathsToReload: indexPathsToReload)
                } else {
                    self.view?.reloadData(newIndexPathsToReload: nil)
                }


            } else if let error = error, error != .fetchInProgress {
                self.view?.showStandardAlert(title: nil, message: error.description)
            }

        }
    }
}

extension MoviesModulePresenter: MoviesModuleInteractorOutput {

}
