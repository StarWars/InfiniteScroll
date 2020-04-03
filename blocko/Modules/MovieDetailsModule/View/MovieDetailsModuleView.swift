import SnapKit
import UIKit

class MovieDetailsModuleView: BaseView {

	// MARK: - Constants -

	// MARK: - Variables -
    private let scrollView: CustomScrollView = {
        let view = CustomScrollView(showsTopMask: false)
        return view
    }()

    private let moviePoster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = ColorProvider.background
        view.contentMode = .scaleAspectFill
        return view
    }()

    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 0.0
        stack.alignment = UIStackView.Alignment.top
        stack.distribution = .fillEqually

        return stack
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standardBold.withSize(13)
        view.numberOfLines = 0
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standard.withSize(11)
        view.numberOfLines = 0
        return view
    }()


	// MARK: - Initialization -

	override init() {
		super.init()

		setupSubviews()
		setupConstraints()
	}

	override func setupSubviews() {
        addSubview(scrollView)
        scrollView.addContentSubview(view: moviePoster)
	}

	override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        moviePoster.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(300)
        }
	}

	// MARK: - Required Init -

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension MovieDetailsModuleView: MovieConfiguration {
    func setup(with movie: Movie?) {
        if let url = APIClient.sharedInstance.backgroundImageURL(movie) {
            moviePoster.kf.setImage(with: url)
        }
    }
}
