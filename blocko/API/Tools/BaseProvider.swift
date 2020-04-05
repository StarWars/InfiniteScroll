import Alamofire
import CocoaLumberjack
import UIKit

/**
 Provider is a class that got extracted from the Interactor, and serves a purpose of encapsulating the repeatable requests handling.

 The app has 1 providers, that fulfill the server communication requirements, for a specific flows.

 1. Movies Service

 Base Provider has a generic response parser, that takes the Decodable types, and returns them when ready.
 *
 */

class BaseProvider {

    func sendRequest<T>(request: BaseRequest, expectedResponseType: T.Type, completion: @escaping ((T?, APIErrorCode?) -> Void)) -> Request? where T: Decodable {

        request.successResponseHandler = { [weak self] response in
            let result = self?.parseResponse(response, expectedType: T.self)
            completion(result, nil)
        }

        request.failureResponseHandler = { [weak self] response, error in
            if let response = response {
                let result = self?.parseResponse(response, expectedType: T.self)
                completion(result, error)
            } else {
                completion(nil, error)
            }
        }

        let request = APIClient.sharedInstance.sendRequest(request: request)

        return request
    }

    func parseResponse<T>(_ response: DataResponse<Data, AFError>, expectedType: T.Type) -> T? where T: Decodable {

        guard let data = response.data else {
            DDLogError("Failed to retrieve data object - CustomerListResponse")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = DateFormatString.ymd.rawValue

            decoder.dateDecodingStrategy = .custom({ decoder -> Date in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)

                var date: Date?

                if dateStr.count == DateFormatString.ymd.rawValue.count {
                    date = dateFormatter.date(from: dateStr)
                } else {
                    /// Some movies have an empty string set in their `release_date` field. Default value is provided.
                    date = dateFormatter.date(from: "1000-01-01")
                }

                guard let unwrappedDate = date else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
                }

                return unwrappedDate
            })
            return try decoder.decode(expectedType, from: data)
        } catch let error {
            DDLogError("[BaseProvider][parseResponse] \(error)")
            return nil
        }

    }

}
