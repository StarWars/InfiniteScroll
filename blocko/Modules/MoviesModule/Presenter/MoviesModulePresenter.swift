import CocoaLumberjack
import Foundation

protocol MoviesModulePresenterInput: BasePresenterInput, FavouriteMovieProtocol {

    var retrievedMovies: [Movie] { get }
    var retrievedSearchResults: [Movie] { get }
    var totalMoviesCount: Int { get }
    var totalSearchResultsCount: Int { get }

    func search(_ title: String)
    func movie(at indexPath: IndexPath) -> Movie?
    func searchResult(at indexPath: IndexPath) -> Movie?
    func showMovieDetails(at indexPath: IndexPath, isSearchActive: Bool)
    func retrieveMovies()
}

protocol MoviesModuleInteractorOutput: class {

}

class MoviesModulePresenter {

    private var movies = [Movie]()
    private var searchResults = [Movie]()

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

    var totalSearchResultsCount: Int {
        return searchResults.count
    }

    var retrievedMovies: [Movie] {
        return movies
    }

    var retrievedSearchResults: [Movie] {
        return searchResults
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

    func searchResult(at indexPath: IndexPath) -> Movie? {
        guard indexPath.row < searchResults.count else {
            DDLogError("invalid index path item requested")
            return nil
        }
        return searchResults[indexPath.row]
    }

    func showMovieDetails(at indexPath: IndexPath, isSearchActive: Bool) {
        var selectedMovie: Movie?

        if isSearchActive {
            selectedMovie = searchResult(at: indexPath)
        } else {
            selectedMovie = movie(at: indexPath)
        }

        guard let movieToShow = selectedMovie else {
            view?.showStandardAlert(title: R.string.localizable.error_failure(), message: "Movie not found")
            return
        }

        wireframe.showDetails(of: movieToShow)
    }

    func retrieveMovies() {
        let initialPageQuery = MovieNowPlayingQuery(page: currentPage)

        interactor.retrieveNowPlayingMovies(query: initialPageQuery) { [weak self] response, error in
            guard let self = self else {
                return
            }

            if let response = response {

                self.movies.append(contentsOf: response.results)

                // It seems that for page `1`, totalResults is different than for page `2` and later
                // Reload to prevent the crash.
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

    func search(_ title: String) {
        guard !title.isEmpty else {
            searchResults = []
            self.view?.reloadData(newIndexPathsToReload: nil)
            return
        }

        let searchMovieQuery = SearchMovieQuery(query: title)
        interactor.searchMovie(query: searchMovieQuery) { response, error in
            if let response = response {
                self.searchResults = response.results
                self.view?.reloadData(newIndexPathsToReload: nil)
            } else if let error = error, error != .fetchInProgress {
                self.view?.showStandardAlert(title: nil, message: error.description)
            }
        }
    }
}

extension MoviesModulePresenter: MoviesModuleInteractorOutput {

}
