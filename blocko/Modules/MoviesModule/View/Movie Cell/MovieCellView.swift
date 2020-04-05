import CocoaLumberjack
import Kingfisher
import UIKit

class MovieCellView: BaseView, MovieConfigurationProtocol, MovieViewContentProtocol {

    // MARK: - Constants -
    private let kDefaultInset: CGFloat = 8
    private var kCellHeight: CGFloat {
        /// Based on documentation, the size of retrieved images will be 500x281 px.
        /// On production, it would be safer to retrieve that values from the API rather then hardcoding them here.
        let aspectRatio = 500.0 / 281.0
        let screenWidth = UIScreen.main.bounds.width
        let backgroundWidth = screenWidth - 2 * kDefaultInset
        let backgroundHeight = backgroundWidth / CGFloat(aspectRatio)

        return CGFloat(Int(backgroundHeight))
    }
    private let kTitleHorizontalInset: CGFloat = 16
    private let kTitleVerticalInset: CGFloat = 16
    private let kRatingInset: CGFloat = 10
    private let kFavInset: CGFloat = 8

    // MARK: - ivars -
    internal let moviePoster: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.roundedEdges(radius: 14)
        view.kf.indicatorType = .activity
        view.isUserInteractionEnabled = true
        return view
    }()

    public lazy var titleWrapper = UIView()

    internal let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = ColorProvider.white
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return view
    }()

    internal let releaseDateLabel: UILabel = {
        let view = UILabel()
        view.textColor = ColorProvider.subtitle
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    public lazy var ratingView = BlurredLabelView()

    internal let favButton = StarButton()

    private var gradientLayer: CAGradientLayer?

    override func setupSubviews() {
        backgroundColor = UIColor.clear

        addSubview(moviePoster)

        applyGradient(from: UIColor.clear, to: ColorProvider.black)

        moviePoster.addSubview(titleWrapper)
        moviePoster.addSubview(ratingView)
        moviePoster.addSubview(favButton)

        titleWrapper.addSubview(titleLabel)
        titleWrapper.addSubview(releaseDateLabel)
    }

    override func setupConstraints() {

        moviePoster.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(kDefaultInset)
            make.top.bottom.equalToSuperview().inset(kDefaultInset)
            make.height.equalTo(kCellHeight)
        }

        titleWrapper.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(kTitleHorizontalInset)
            make.bottom.equalToSuperview().inset(kTitleVerticalInset)
            make.top.greaterThanOrEqualToSuperview()
            make.trailing.equalToSuperview().inset(kDefaultInset)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }

        ratingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(kRatingInset)
            make.trailing.equalToSuperview().inset(kRatingInset)
            make.leading.greaterThanOrEqualToSuperview().inset(kRatingInset)
            make.size.equalTo(favButton)
        }

        favButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(kFavInset)
            make.centerY.equalTo(ratingView)
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalToSuperview().inset(kFavInset)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading)
        }

    }

    private func applyGradient(from: UIColor, to: UIColor) {

        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }

        let cellWidth = UIScreen.main.bounds.width - 2 * kDefaultInset
        let cellHeight = kCellHeight
        let bounds = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)

        let newGradient = moviePoster.createVerticalGradient(from: from, to: to, bounds: bounds)

        gradientLayer = newGradient

        moviePoster.layer.addSublayer(newGradient)

    }

}
