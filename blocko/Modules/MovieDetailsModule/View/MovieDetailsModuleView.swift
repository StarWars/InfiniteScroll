import SnapKit
import UIKit

class MovieDetailsModuleView: BaseView, MovieViewContentProtocol, MovieConfigurationProtocol {

	// MARK: - Constants -
    private let kPosterHeight: CGFloat = 300
    private let kFavInset: CGFloat = 8
    private let kRatingInset: CGFloat = 10
    private let kDefaultInset: CGFloat = 8

	// MARK: - Variables -

    private(set) lazy var stackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 8.0
        stack.alignment = UIStackView.Alignment.top
        stack.distribution = .fill

        return stack
    }()

    private let scrollView = CustomScrollView()

    internal let titleLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standardBold.withSize(22)
        view.numberOfLines = 0
        return view
    }()

    internal let moviePoster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = ColorProvider.background
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()

    internal let releaseDateLabel: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standard.withSize(12)
        return view
    }()

    internal let descriptionLabel: UILabel? = {
        let view = UILabel()
        view.font = FontProvider.standard.withSize(14)
        view.numberOfLines = 0
        return view
    }()

    lazy var ratingView = BlurredLabelView()

    internal let favButton = StarButton()

	// MARK: - Setup -

	override func setupSubviews() {
        addSubview(scrollView)

        moviePoster.addSubview(ratingView)
        moviePoster.addSubview(favButton)

        scrollView.addContentSubview(view: moviePoster)
        scrollView.addContentSubview(view: stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(releaseDateLabel)

        if let descriptionLabel = descriptionLabel {
            stackView.addArrangedSubview(descriptionLabel)
        }
	}

	override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(safeArea.top)
        }

        favButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(kFavInset)
            make.centerY.equalTo(ratingView)
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalToSuperview().inset(kFavInset)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading)
        }

        moviePoster.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(kPosterHeight)
        }

        ratingView.snp.makeConstraints { make in
            make.size.equalTo(favButton)
            make.top.equalToSuperview().inset(kRatingInset)
            make.trailing.equalToSuperview().inset(kRatingInset)
            make.leading.greaterThanOrEqualToSuperview().inset(kRatingInset)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.bottom).inset(-kDefaultInset)
            make.leading.trailing.bottom.equalToSuperview().inset(kDefaultInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

        descriptionLabel?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }

	}
}
