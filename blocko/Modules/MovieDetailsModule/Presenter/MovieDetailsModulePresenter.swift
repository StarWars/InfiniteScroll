import Foundation

protocol MovieDetailsModulePresenterInput: BasePresenterInput {
    var movie: Movie { get }
}

protocol MovieDetailsModuleInteractorOutput: class {

}

class MovieDetailsModulePresenter {

    private var currentMovie: Movie

    weak var view: MovieDetailsModuleViewInput?
    let interactor: MovieDetailsModuleInteractorInput
    let wireframe: MovieDetailsModuleWireframeInput

    init(movie: Movie,
         interactor: MovieDetailsModuleInteractorInput,
         wireframe: MovieDetailsModuleWireframeInput) {
        self.interactor = interactor
        self.wireframe = wireframe
        self.currentMovie = movie
    }

}

extension MovieDetailsModulePresenter: MovieDetailsModulePresenterInput {

    var baseWireframe: BaseWireframeInput? {
        return wireframe
    }
    
    var movie: Movie {
        return currentMovie
    }
    
}

extension MovieDetailsModulePresenter: MovieDetailsModuleInteractorOutput {

}
