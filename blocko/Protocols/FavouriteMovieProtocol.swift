protocol FavouriteMovieProtocol {
    func toggleFavourite(_ movie: Movie)
}

extension FavouriteMovieProtocol {
    func toggleFavourite(_ movie: Movie) {
        DataController.shared.toggle(movie: movie)
    }
}
