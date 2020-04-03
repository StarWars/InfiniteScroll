import CocoaLumberjack
import Kingfisher
import UIKit

class MovieCellView: UIView, MovieCellConfiguration {

    // MARK: - Constants -
    private let kDefaultInset: CGFloat = 8
    private let kCellHeight: CGFloat = 160
    private let kTitleHorizontalInset: CGFloat = 16
    private let kTitleVerticalInset: CGFloat = 17
    private let kTimeHorizontalInset: CGFloat = 11
    private let kTimeVerticalInset: CGFloat = 10

    // MARK: - ivars -
    public lazy var cellBackground: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.roundedEdges()
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

    public lazy var timeView = BlurredLabelView()

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
        cellBackground.addSubview(timeView)

        titleWrapper.addSubview(cellTitle)
        titleWrapper.addSubview(cellSubTitle)
    }

    private func setupConstraints() {

        cellBackground.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(kDefaultInset)
            make.top.bottom.equalToSuperview().inset(kDefaultInset / 2.0)
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

        timeView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(kTimeVerticalInset)
            make.trailing.equalToSuperview().inset(kTimeHorizontalInset)
            make.leading.greaterThanOrEqualTo(kTimeVerticalInset)
        }

    }

    func setup(with movie: Movie?) {
        if let url = APIClient.sharedInstance.backgroundImageURL(movie) {
            cellBackground.kf.setImage(with: url) { result in
                switch result {
                case .failure(let error):
                    DDLogError(error.errorDescription ?? "Image retrieval error")
                case .success(_):
                    break
                }

            }
        }

        cellTitle.text = movie?.title

        if let releaseDate = movie?.releaseDate.timeIntervalSince1970.timestampToString(format: DateFormatString.ymd) {
            cellSubTitle.text = "\(R.string.localizable.release_date_subtitle()) \(releaseDate)"
        }

        if let voteAverate = movie?.voteAverage {
            timeView.setup(title: "\(voteAverate)")
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
