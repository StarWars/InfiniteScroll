import CocoaLumberjack
import UIKit

protocol MoviesModuleViewInput: BaseViewInput {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func reloadData()
}

class MoviesModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -

	fileprivate var customView: MoviesModuleView { return forceCast(view) }
    let presenter: MoviesModulePresenterInput

	// MARK: - Initialization -

    override init(presenter: BasePresenterInput) {
        //swiftlint:disable force_cast
        self.presenter = presenter as! MoviesModulePresenterInput
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

	private func setupView() {
        title = R.string.localizable.movies_module_title()
        bottomLayoutConstraint = customView.bottomLayoutConstraint
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        view.backgroundColor = ColorProvider.background
	}

	private func setupActions() {

	}

	override func loadView() {
		view = MoviesModuleView()
	}

}

extension MoviesModuleViewController: MoviesModuleViewInput {

    override func reloadData() {
        customView.refreshControl.endRefreshing()
        customView.tableView.reloadData()
    }

}

extension MoviesModuleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showMovieDetails(at: indexPath)
    }
}

extension MoviesModuleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let moviesCount = presenter.retrievedMovies.count

        if moviesCount == 0 {
            tableView.backgroundView = EmptyTableView(title: R.string.localizable.cta_empty_movies())
        } else {
            tableView.backgroundView = nil
        }

        return moviesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieCell.self)

        let movie = presenter.movie(at: indexPath)
        cell.setup(with: movie)

        return cell

    }

}
