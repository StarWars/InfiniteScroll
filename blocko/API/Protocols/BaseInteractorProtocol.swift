import Alamofire
import CocoaLumberjack
import UIKit

protocol BaseInteractorProtocol {
    func handleResponse(_ response: DataResponse<Data, AFError>, withRequest request: BaseRequest)
}

extension BaseInteractorProtocol {

    func handleResponse(_ response: DataResponse<Data, AFError>, withRequest request: BaseRequest) {

        guard let statusCode = response.response?.statusCode, let statusEnum = APIErrorCode(rawValue: statusCode) else {
            DDLogError("[ERROR] Couldn't retrieve response status")
            request.failureResponseHandler?(response, APIErrorCode.unknown)
            return
        }

        if let urlResponse = response.response, 200...299 ~= urlResponse.statusCode {
            request.successResponseHandler?(response)
        } else {
            DDLogError("[ERROR] \(statusEnum.description)")
            request.failureResponseHandler?(response, statusEnum)
        }

    }

}
