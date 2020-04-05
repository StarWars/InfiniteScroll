import CocoaLumberjack
import CoreData
import UIKit

#if DEBUG
let ddloglevel = DDLogLevel.verbose
#else
let ddloglevel = DDLogLevel.off
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupRootController()
        setupThirdPartySDKs()
        setupUIAppearance()

        return true
    }

    // MARK: - 3rd Party SDKs -

    private func setupThirdPartySDKs() {
        setupLoggers()
    }

    private func setupLoggers() {
        let logger = DDOSLogger.sharedInstance
        DDLog.add(logger)
        dynamicLogLevel = ddloglevel
        logger.logFormatter = LumberjackLogFormatter()
    }

    // MARK: - Navigation -

    private func setupUIAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: ColorProvider.white]
    }

    private func setupRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootController = MoviesModuleWireframe.setupMoviesModule()
        window?.rootViewController = UINavigationController(rootViewController: rootController)
        window?.makeKeyAndVisible()
    }

}
