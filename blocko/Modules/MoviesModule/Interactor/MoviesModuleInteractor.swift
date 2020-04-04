import Foundation

protocol MoviesModuleInteractorInput: BaseInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void))
}

class MoviesModuleInteractor: BaseProvider {

    weak var output: MoviesModuleInteractorOutput?

    private var isFetchInProgress = false

}

extension MoviesModuleInteractor: MoviesModuleInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void)) {

        guard !isFetchInProgress else {
            completion(nil, APIErrorCode.fetchInProgress)
            return
        }

        isFetchInProgress = true

        let request = MovieNowPlayingRequest(query: query)

        sendRequest(request: request, expectedResponseType: MovieNowPlayingResponse.self) { [weak self] response, error in
            self?.isFetchInProgress = false
            completion(response, error)
        }

    }
}
