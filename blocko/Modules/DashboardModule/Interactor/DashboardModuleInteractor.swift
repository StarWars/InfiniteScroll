import Alamofire
import Foundation

protocol DashboardModuleInteractorInput: BaseInteractorInput {
    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void))
}

class DashboardModuleInteractor: BaseProvider {

    weak var output: DashboardModuleInteractorOutput?

}

extension DashboardModuleInteractor: DashboardModuleInteractorInput {

    func retrieveNowPlayingMovies(query: MovieNowPlayingQuery, completion: @escaping ((MovieNowPlayingResponse?, APIErrorCode?) -> Void)) {

        let request = MovieNowPlayingRequest(query: query)

        sendRequest(request: request, expectedResponseType: MovieNowPlayingResponse.self) { response, error in
            completion(response, error)
        }

    }
    
}
