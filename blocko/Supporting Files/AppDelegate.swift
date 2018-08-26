import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupThirdPartySDKs()
        setupRootController()

        return true
    }

    // MARK: - 3rd Party SDKs -

    private func setupThirdPartySDKs() {
        Fabric.with([Crashlytics.self])
    }

    // MARK: - Navigation -

    private func setupRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootController = MainTabsModuleWireframe.setupMainTabsModule()
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }

}

