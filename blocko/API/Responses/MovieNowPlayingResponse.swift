import Foundation

public struct Dates: Codable {
    public let maximum: Date
    public let minimum: Date
}

public struct Movie: Codable {
    public let popularity: Double
    public let voteCount: Int
    public let video: Bool
    public let posterPath: String
    public let id: Int
    public let adult: Bool
    public let backdropPath: String?
    public let originalLanguage: String
    public let originalTitle: String
    public let genreIds: [Int]
    public let title: String
    public let voteAverage: Double
    public let overview: String
    public let releaseDate: Date

    private enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}

public struct MovieNowPlayingResponse: Codable {

    public let results: [Movie]
    public let page: Int
    public let totalResults: Int
    public let dates: Dates
    public let totalPages: Int

    private enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
        case dates
        case totalPages = "total_pages"
    }
}
