import SnapKit
import UIKit

class MovieDetailsModuleView: BaseView {

	// MARK: - Constants -
    private let kRatingInset: CGFloat = 10
    private let kDefaultInset: CGFloat = 8

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
        stack.distribution = .fill

        return stack
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standardBold.withSize(22)
        view.numberOfLines = 0
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standard.withSize(14)
        view.numberOfLines = 0
        return view
    }()

    public lazy var ratingView = BlurredLabelView()


	// MARK: - Initialization -

	override init() {
		super.init()

		setupSubviews()
		setupConstraints()
	}

	override func setupSubviews() {
        addSubview(scrollView)

        moviePoster.addSubview(ratingView)

        scrollView.addContentSubview(view: moviePoster)
        scrollView.addContentSubview(view: stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
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

        ratingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(kRatingInset)
            make.trailing.equalToSuperview().inset(kRatingInset)
            make.leading.greaterThanOrEqualTo(kRatingInset)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.bottom).inset(-kDefaultInset)
            make.leading.trailing.bottom.equalToSuperview().inset(kDefaultInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

	}

	// MARK: - Required Init -

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension MovieDetailsModuleView: MovieConfiguration {

    func setup(with movie: Movie?) {
        guard let movie = movie else {
            setupCleanState()
            return
        }

        if let url = APIClient.sharedInstance.backgroundImageURL(movie) {
            moviePoster.kf.setImage(with: url)
        }

        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview

        if let voteAverate = movie.voteAverage {
            ratingView.setup(title: "\(voteAverate)")
        }
    }

    private func setupCleanState() {
        moviePoster.kf.cancelDownloadTask()
        moviePoster.image = R.image.close()
        titleLabel.text = nil
        descriptionLabel.text = nil
        ratingView.setup(title: "")
    }
}
