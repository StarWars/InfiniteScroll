import Foundation

protocol MoviesModuleInteractorInput: BaseInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void))
}

class MoviesModuleInteractor: BaseProvider {

    weak var output: MoviesModuleInteractorOutput?

}

extension MoviesModuleInteractor: MoviesModuleInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void)) {

        let request = MovieNowPlayingRequest(query: query)

        sendRequest(request: request, expectedResponseType: MovieNowPlayingResponse.self) { response, error in
            completion(response, error)
        }

    }
}
