import Alamofire
import UIKit

public struct MovieNowPlayingQuery: Codable {
    public let page: Int
}

class MovieNowPlayingRequest: BaseRequest {

    convenience init(query: MovieNowPlayingQuery) {
        self.init()
        method = .get
        parametersEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .brackets, boolEncoding: .numeric)
        url = "movie/now_playing"

        bodyParams = query.dictionary
    }
}
