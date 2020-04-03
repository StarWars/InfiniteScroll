import UIKit

protocol DashboardModuleViewInput: BaseViewInput {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func reloadData()
}

class DashboardModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -

	fileprivate var customView: DashboardModuleView { return forceCast(view as Any) }
	var output: DashboardModuleViewOutput?
    override var basePresenter: BasePresenterInput? { return output }

	// MARK: - Initialization -

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupActions()
	}

	private func setupView() {

	}

	private func setupActions() {

	}

	override func loadView() {
		view = DashboardModuleView()
	}

}

extension DashboardModuleViewController: DashboardModuleViewInput {
    func reloadData() {
        
    }

    func showLoadingIndicator() {

    }

    func hideLoadingIndicator() {

    }
}
