import CocoaLumberjack
import Reusable
import SnapKit
import UIKit

class MovieCell: UITableViewCell, Reusable {

    var actionHandler: ((Movie?) -> Void)?

    private var currentMovie: Movie?
    private lazy var movieView = MovieCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupActions()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func setupView() {
        tintColor = ColorProvider.white
        contentView.addSubview(movieView)
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    private func setupConstraints() {

        movieView.setContentCompressionResistancePriority(.required, for: .vertical)
        movieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    private func setupActions() {
        movieView.favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
    }

    @objc
    private func favButtonPressed() {
        actionHandler?(currentMovie)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggleFavButton() {
        movieView.favButton.toggleSelection()
    }

    func setup(with movie: Movie?) {
        self.currentMovie = movie
        movieView.setup(with: movie)
    }
}
