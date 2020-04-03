import SnapKit
import UIKit

class MoviesModuleView: BaseView {

    lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()

        let attributes = [NSAttributedString.Key.font: FontProvider.standard.withSize(11),
                          NSAttributedString.Key.foregroundColor: ColorProvider.white]

        view.tintColor = ColorProvider.white
        view.attributedTitle = NSAttributedString(string: R.string.localizable.fetching_movies(), attributes: attributes)

        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()

        view.backgroundColor = ColorProvider.background
        view.register(cellType: MovieCell.self)
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 44
        view.separatorStyle = .none
        view.refreshControl = refreshControl

        return view
    }()

    override func setupSubviews() {
        addSubview(tableView)
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.top)
            make.bottom.equalTo(safeArea.bottom)
            make.leading.equalTo(safeArea.leading)
            make.trailing.equalTo(safeArea.trailing)
        }
    }

}
