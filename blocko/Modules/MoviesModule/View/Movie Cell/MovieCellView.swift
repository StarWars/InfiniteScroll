import CocoaLumberjack
import Kingfisher
import UIKit

class MovieCellView: UIView, MovieConfiguration {

    // MARK: - Constants -
    private let kStarButtonSize = CGSize(width: 45, height: 45)
    private let kDefaultInset: CGFloat = 8
    private var kCellHeight: CGFloat {
        /// Based on documentation, the size of retrieved images will be 500x281 px.
        /// On production, it would be safer to retrieve that values from the API rather then hardcode them.
        let aspectRatio = 500.0 / 281.0
        let screenWidth = UIScreen.main.bounds.width
        let backgroundWidth = screenWidth - 2 * kDefaultInset
        let backgroundHeight = backgroundWidth / CGFloat(aspectRatio)

        return backgroundHeight
    }
    private let kTitleHorizontalInset: CGFloat = 16
    private let kTitleVerticalInset: CGFloat = 16
    private let kRatingInset: CGFloat = 10

    // MARK: - ivars -
    public lazy var cellBackground: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.roundedEdges(radius: 14)
        view.kf.indicatorType = .activity
        return view
    }()

    public lazy var titleWrapper = UIView()

    public lazy var cellTitle: UILabel = {
        let view = UILabel()
        view.textColor = ColorProvider.title
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return view
    }()

    public lazy var cellSubTitle: UILabel = {
        let view = UILabel()
        view.textColor = ColorProvider.subtitle
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return view
    }()

    public lazy var ratingView = BlurredLabelView()

    public lazy var starButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.yellow
        return view
    }()

    private var gradientLayer: CAGradientLayer?

    convenience init() {
        self.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        backgroundColor = UIColor.clear

        addSubview(cellBackground)

        applyGradient(from: UIColor.clear, to: ColorProvider.black)

        cellBackground.addSubview(titleWrapper)
        cellBackground.addSubview(ratingView)
        cellBackground.addSubview(starButton)

        titleWrapper.addSubview(cellTitle)
        titleWrapper.addSubview(cellSubTitle)
    }

    private func setupConstraints() {

        cellBackground.snp.makeConstraints { make in
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

        cellTitle.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        cellSubTitle.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(cellTitle.snp.bottom)
        }

        ratingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(kRatingInset)
            make.trailing.equalToSuperview().inset(kRatingInset)
            make.leading.greaterThanOrEqualTo(kRatingInset)
        }

        starButton.snp.makeConstraints { make in
            make.size.equalTo(kStarButtonSize)
            make.top.equalTo(ratingView)
            make.leading.equalToSuperview().inset(kRatingInset)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading)
        }

    }

    func setup(with movie: Movie?) {
        if let url = APIClient.sharedInstance.backgroundImageURL(movie) {
            cellBackground.kf.setImage(with: url, options: KingfisherOptionsInfo([.backgroundDecode, .forceTransition]))
        } else {
            cellBackground.kf.cancelDownloadTask()
            cellBackground.image = nil
        }

        cellTitle.text = movie?.title

        if let releaseDate = movie?.releaseDate?.timeIntervalSince1970.timestampToString(format: DateFormatString.ymd) {
            cellSubTitle.text = "\(R.string.localizable.release_date_subtitle()) \(releaseDate)"
        }

        if let voteAverate = movie?.voteAverage {
            ratingView.setup(title: "\(voteAverate)")
        }

    }

    private func applyGradient(from: UIColor, to: UIColor) {

        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }

        let cellWidth = UIScreen.main.bounds.width - 2 * kDefaultInset
        let cellHeight = kCellHeight
        let bounds = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)

        let newGradient = cellBackground.createVerticalGradient(from: from, to: to, bounds: bounds)

        gradientLayer = newGradient

        cellBackground.layer.addSublayer(newGradient)

    }

}
