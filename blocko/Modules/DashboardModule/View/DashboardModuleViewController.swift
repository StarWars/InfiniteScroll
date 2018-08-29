import UIKit

protocol DashboardModuleViewInput: BaseViewInput {

}

class DashboardModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -

	fileprivate var customView: DashboardModuleView { return forceCast(view) }
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

}
