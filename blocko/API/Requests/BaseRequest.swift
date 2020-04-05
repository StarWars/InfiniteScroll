import Alamofire
import Foundation

class BaseRequest: NSObject {

    var url: String?
    var bodyParams: [String: Any]? = [:]
    var method: HTTPMethod = .get
    var parametersEncoding: Alamofire.ParameterEncoding = URLEncoding.default

    // Some of the requests has default responseHandlers
    var successResponseHandler: ((DataResponse<Data, AFError>) -> Void)?
    var failureResponseHandler: ((DataResponse<Data, AFError>?, _ errorCode: APIErrorCode?) -> Void)?

}
