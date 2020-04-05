import Alamofire
import UIKit

public struct SearchMovieQuery: Codable {
    public let query: String
}

class SearchMovieRequest: BaseRequest {

    convenience init(query: SearchMovieQuery) {
        self.init()
        method = .get
        parametersEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .brackets, boolEncoding: .numeric)
        url = "search/movie"

        bodyParams = query.dictionary
    }
}
