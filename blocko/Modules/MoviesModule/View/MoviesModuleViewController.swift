import CocoaLumberjack
import RxCocoa
import RxSwift
import UIKit

protocol MoviesModuleViewInput: BaseViewInput {
    func reloadData(newIndexPathsToReload: [IndexPath]?)
}

class MoviesModuleViewController: BaseViewController {

	// MARK: - Constants -

	// MARK: - Variables -
    private var searchTask: DispatchWorkItem?

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.tintColor = ColorProvider.white
        controller.searchBar.barTintColor = ColorProvider.white
        controller.searchBar.placeholder = R.string.localizable.type_to_search()
        controller.searchBar.autocapitalizationType = .none
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.searchBarStyle = UISearchBar.Style.minimal
        controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
        return controller
    }()

	fileprivate var customView: MoviesModuleView { return forceCast(view as Any) }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.tableView.reloadData()
    }

	private func setupView() {
        title = R.string.localizable.movies_module_title()
        bottomLayoutConstraint = customView.bottomLayoutConstraint
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.prefetchDataSource = self
        view.backgroundColor = ColorProvider.background
        setupSearchController()
	}

	private func setupActions() {
        customView.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
	}

    private func setupSearchController() {

        searchController.searchResultsUpdater = self

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            customView.tableView.tableHeaderView = searchController.searchBar
        }

        definesPresentationContext = true
    }

	override func loadView() {
		view = MoviesModuleView()
	}

    @objc
    private func pullToRefresh() {
        if presenter.retrievedMovies.isEmpty {
            presenter.retrieveMovies()
        } else {
            stopPullToRefreshAnimation()
        }
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if isFiltering {
            return indexPath.row >= presenter.retrievedSearchResults.count
        } else {
            return indexPath.row >= presenter.retrievedMovies.count
        }
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = customView.tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }

    func filterContentForSearchText(_ searchText: String) {
        presenter.search(searchText)
    }
}

extension MoviesModuleViewController: MoviesModuleViewInput {

    func reloadData(newIndexPathsToReload: [IndexPath]?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            guard let newIndexPathsToReload = newIndexPathsToReload else {
                self.customView.tableView.reloadData()
                return
            }

            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            self.customView.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }

    func stopPullToRefreshAnimation() {
        DispatchQueue.main.async {
            self.customView.refreshControl.endRefreshing()
        }
    }

}

extension MoviesModuleViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter.retrieveMovies()
        }
    }
}

extension MoviesModuleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showMovieDetails(at: indexPath, isSearchActive: isFiltering)
    }
}

extension MoviesModuleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var moviesCount = 0

        if isFiltering {
            moviesCount = presenter.totalSearchResultsCount
            DDLogError("movies count: \(moviesCount)")
        } else {
            moviesCount = presenter.totalMoviesCount
        }

        if moviesCount == 0 {
            tableView.backgroundView = EmptyTableView(title: R.string.localizable.cta_empty_movies())
        } else {
            tableView.backgroundView = nil
        }

        return moviesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieCell.self)

        if isLoadingCell(for: indexPath) {
            cell.setup(with: nil)
        } else {
            var movie: Movie?
            if isFiltering {
                movie = presenter.searchResult(at: indexPath)
            } else {
                movie = presenter.movie(at: indexPath)
            }
            cell.setup(with: movie)
        }

        cell.actionHandler = { [unowned self] movie in
            guard let movie = movie else {
                return
            }

            cell.toggleFavButton()

            self.presenter.toggleFavourite(movie)
        }

        return cell

    }

}

extension MoviesModuleViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.customView.tableView.reloadData()
    }
}

extension MoviesModuleViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        self.searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            guard let searchText = self?.searchController.searchBar.text else {
                DDLogError("Failed to unwrap searchBar")
                return
            }
            self?.filterContentForSearchText(searchText)
        }

        self.searchTask = task

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}
