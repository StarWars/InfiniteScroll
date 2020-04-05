import UIKit
import Kingfisher

protocol MovieViewContentProtocol {
    var titleLabel: UILabel { get }
    var moviePoster: UIImageView { get }
    var releaseDateLabel: UILabel { get }
    var descriptionLabel: UILabel? { get }
    var ratingView: BlurredLabelView { get }
    var favButton: StarButton { get }
}

extension MovieViewContentProtocol {
    var descriptionLabel: UILabel? { return nil }
}

protocol MovieConfigurationProtocol: class where Self: MovieViewContentProtocol {
    func setup(with movie: Movie?)
}

extension MovieConfigurationProtocol {
    func setup(with movie: Movie?) {
        if let url = APIClient.sharedInstance.backgroundImageURL(movie) {
            moviePoster.kf.setImage(with: url, options: KingfisherOptionsInfo([.backgroundDecode, .forceTransition]))
        } else {
            moviePoster.kf.cancelDownloadTask()
            moviePoster.image = nil
        }

        titleLabel.text = movie?.title

        descriptionLabel?.text = movie?.overview

        if let releaseDate = movie?.releaseDateFormatted {
            releaseDateLabel.text = releaseDate
        } else {
            releaseDateLabel.text = nil
        }

        if let voteAverate = movie?.voteAverage {
            ratingView.setup(title: "\(voteAverate)")
        } else {
            ratingView.setup(title: "")
        }

        if let movieID = movie?.id {
            DataController.shared.get(movie: "\(movieID)", completion: { [weak self] movie, error in
                self?.favButton.isSelected = movie != nil
            })
        }
    }
}
