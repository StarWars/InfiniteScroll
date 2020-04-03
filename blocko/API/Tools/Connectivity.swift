import Alamofire
import CocoaLumberjack

/// ***
/// Instead of reaching for the external reachability library,
/// I implemented the Alamofire based Connectivity class that serves the same purpose.
/// ***

class Connectivity {

    private let connectivityManager = NetworkReachabilityManager()

    static let sharedInstance = Connectivity()

    var isInternetAvailable: Bool {
        return connectivityManager?.isReachable ?? false
    }

    func listenForReachability() {

        self.connectivityManager?.startListening(onUpdatePerforming: { status in
            DDLogVerbose("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                DDLogVerbose("Not reachable")
            case .reachable(.cellular):
                DDLogVerbose("Reachable via WWAN")
            case .reachable(.ethernetOrWiFi):
                DDLogVerbose("Reachable via Wi-Fi")
            default:
                DDLogVerbose("Unknown reachability")
            }
        })
    }
}
