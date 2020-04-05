import Alamofire
import Foundation

protocol MoviesModuleInteractorInput: BaseInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void))

    func searchMovie(query: SearchMovieQuery, completion: @escaping ((SearchMovieResponse?, APIErrorCode?) -> Void))
}

class MoviesModuleInteractor: BaseProvider {

    weak var output: MoviesModuleInteractorOutput?

    private var isFetchInProgress = false
    private var searchRequest: Request?

}

extension MoviesModuleInteractor: MoviesModuleInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void)) {

        guard !isFetchInProgress else {
            completion(nil, APIErrorCode.fetchInProgress)
            return
        }

        isFetchInProgress = true

        let request = MovieNowPlayingRequest(query: query)

        _ = sendRequest(request: request, expectedResponseType: MovieNowPlayingResponse.self) { [weak self] response, error in
            self?.isFetchInProgress = false
            completion(response, error)
        }

    }

    func searchMovie(query: SearchMovieQuery, completion: @escaping ((SearchMovieResponse?, APIErrorCode?) -> Void)) {

        searchRequest?.cancel()

        let request = SearchMovieRequest(query: query)

        searchRequest = sendRequest(request: request, expectedResponseType: SearchMovieResponse.self) { response, error in
            completion(response, error)
        }

    }
}
