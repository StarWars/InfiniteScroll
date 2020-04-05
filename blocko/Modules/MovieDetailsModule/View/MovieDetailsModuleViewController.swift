import UIKit

protocol MovieDetailsModuleViewInput: class {

}

class MovieDetailsModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -

	fileprivate var customView: MovieDetailsModuleView { return forceCast(view as Any) }
    let presenter: MovieDetailsModulePresenterInput

	// MARK: - Initialization -

    override init(presenter: BasePresenterInput) {
        //swiftlint:disable force_cast
        self.presenter = presenter as! MovieDetailsModulePresenterInput
        //swiftlint:enable force_cast
        super.init(presenter: presenter)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupActions()
	}
    override func setupNavigationBar() {
        super.setupNavigationBar()
        createXButton()
    }

	private func setupView() {
        title = presenter.movie.title
        customView.setup(with: presenter.movie)
	}

	private func setupActions() {
        customView.favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
	}

	override func loadView() {
		view = MovieDetailsModuleView()
	}

    override func xButtonSelected() {
        presenter.closePressed()
    }

    @objc
    private func favButtonPressed() {
        customView.favButton.toggleSelection()
        presenter.toggleFavourite(presenter.movie)
    }

}

extension MovieDetailsModuleViewController: MovieDetailsModuleViewInput {

}
