import UIKit

protocol MoviesModuleWireframeInput: BaseWireframeInput {
    func showDetails(of movie: Movie)
}

class MoviesModuleWireframe: BaseWireframe {

    class func setupMoviesModule() -> UIViewController {
        let wireframe = MoviesModuleWireframe()
        let interactor = MoviesModuleInteractor()
        let presenter = MoviesModulePresenter(interactor: interactor, wireframe: wireframe)
        let viewController = MoviesModuleViewController(presenter: presenter)

        presenter.view = viewController
        interactor.output = presenter

        wireframe.currentViewController = viewController

        return viewController
    }

}

extension MoviesModuleWireframe: MoviesModuleWireframeInput {

    func showDetails(of movie: Movie) {
        DispatchQueue.main.async {
            let attributesForm = MovieDetailsModuleWireframe.setupMovieDetailsModule(movie: movie)
            let navigationWrapped = UINavigationController(rootViewController: attributesForm)
            self.currentViewController?.present(navigationWrapped, animated: true, completion: nil)
        }
    }

}
