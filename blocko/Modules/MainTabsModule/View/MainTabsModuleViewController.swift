import UIKit

protocol MainTabsModuleViewInput: BaseViewInput {

}

class MainTabsModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -

	fileprivate var customView: MainTabsModuleView { return forceCast(view) }
	var output: MainTabsModuleViewOutput?
    override var basePresenter: BasePresenterInput? { return output }

    private var viewControllers = [UIViewController]()
    private var currentViewController: UIViewController?

	// MARK: - Initialization -

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupActions()

        customView.tabBar.selectTabAtIndex(index: 0)
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

	private func setupView() {
        navigationController?.isNavigationBarHidden = true
        setupViewControllers()
	}

    private func setupViewControllers() {
        // Test view controllers
        let homeController = BaseViewController()
        homeController.title = "Home"

        let mainController = BaseViewController()
        mainController.title = "Software Network"

        let profileController = BaseViewController()
        profileController.title = "Profile"

        for controller in [homeController, mainController, profileController] {
            viewControllers.append(NavigationController(rootViewController: controller))
        }
    }

	private func setupActions() {
        customView.tabBar.delegate = self
	}

	override func loadView() {
		view = MainTabsModuleView()
	}

}

extension MainTabsModuleViewController: MainTabsModuleViewInput {

}

extension MainTabsModuleViewController: CustomTabBarDelegate {

    func didChooseTab(index: Int) {
        let controller = viewControllers[index]

        if controller != currentViewController {
            currentViewController?.view.removeFromSuperview()

            embedViewController(viewController: controller, inView: customView.containerView)
            currentViewController = controller

        } else {
            if let navController = controller as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }

    }

}
