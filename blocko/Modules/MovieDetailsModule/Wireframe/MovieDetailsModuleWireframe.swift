import UIKit

protocol MovieDetailsModuleWireframeInput: BaseWireframeInput {

}

class MovieDetailsModuleWireframe: BaseWireframe {

    class func setupMovieDetailsModule(movie: Movie) -> UIViewController {
        let wireframe = MovieDetailsModuleWireframe()
        let interactor = MovieDetailsModuleInteractor()
        let presenter = MovieDetailsModulePresenter(movie: movie, interactor: interactor, wireframe: wireframe)
        let viewController = MovieDetailsModuleViewController(presenter: presenter)

        presenter.view = viewController
        interactor.output = presenter

        wireframe.currentViewController = viewController

        return viewController
    }

}

extension MovieDetailsModuleWireframe: MovieDetailsModuleWireframeInput {

}
