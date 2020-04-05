
import CocoaLumberjack
import CoreData
import CoreLocation
import Foundation

class DataController: NSObject {

    enum Errors: Int {
        case dbError
        case insertError
    }

    // MARK: - Constants -
    private let kDomain = "pl.appbeat.dxcchallenge"
    static let shared = DataController()
    

    // MARK: - Variables -

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "movies")

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                DDLogError("Unresolved error \(error), \(error.userInfo)")
            } else {
                DDLogDebug("PersistentContainer initialization finished \(description)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return container

    }()

    // MARK: - Init -
    private override init() {} // Prevent clients from creating another instance.


    // MARK: - Helpers: General -

    func purgeDB() {
        purgeFavouriteMovies()
    }

    func purgeFavouriteMovies() {

        let context = DataController.shared.persistentContainer.viewContext

        let moviesResultsController = DataController.favouriteMoviesFetchedResultsController(predicate: nil, sortDescriptors: nil, fetchLimit: nil)

        context.perform {
            try? moviesResultsController.performFetch()

            if let movies = moviesResultsController.fetchedObjects {
                for movie in movies {
                    context.delete(movie)
                }
            }

            self.save()
        }
    }

    // MARK: - Fetched results controllers -
    @objc
    private static func favouriteMoviesFetchedResultsController(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: NSNumber?) -> NSFetchedResultsController<RMovie> {

        let context = DataController.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RMovie>(entityName: "RMovie")

        // Add Sort Descriptors
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors = []
        }

        // Add Predicate
        fetchRequest.predicate = predicate

        // Limit results count if needed
        if let limit = fetchLimit {
            fetchRequest.fetchLimit = limit.intValue
        }

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController<RMovie>(fetchRequest: fetchRequest,
                                                                              managedObjectContext: context,
                                                                              sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }

    // MARK: - CRUD -

    func toggle(movie: Movie) {
        guard let movieID = movie.id else {
            DDLogError("Failed to unwrap movie.id")
            return
        }

        let stringID = "\(movieID)"

        get(movie: stringID) { [weak self] rMovie, error in
            guard let self = self else {
                return
            }

            if rMovie != nil {
                self.remove(movieID: stringID) { error in
                    if let error = error {
                        DDLogError("\(error)")
                    }
                }
            } else {
                self.add(movie: movie) { error in
                    if let error = error {
                        DDLogError("\(error)")
                    }
                }
            }
        }
    }

    func get(movie id: String, completion: @escaping ((RMovie?, NSError?) -> Void) ) {

        let predicate = NSPredicate(format: "movieID = %@", id)
        let fetchedResultsController = DataController.favouriteMoviesFetchedResultsController(predicate: predicate,
                                                                                   sortDescriptors: nil,
                                                                                   fetchLimit: 1)

        let context = DataController.shared.persistentContainer.viewContext

        context.perform {
            try? fetchedResultsController.performFetch()
            completion(fetchedResultsController.fetchedObjects?.first, nil)
        }
    }

    private func add(movie: Movie, completion: @escaping ((NSError?) -> Void)) {

        guard let id = movie.id else {
            let error = NSError(domain: kDomain, code: DataController.Errors.insertError.rawValue, userInfo: ["localizedDescription": "Couldn't insert entity type RMovie to the DB"])
            completion(error)
            return
        }

        let context = DataController.shared.persistentContainer.viewContext

        let movieID = "\(id)"

        DataController.shared.get(movie: movieID) { [weak self] existingMovie, error in
            guard let self = self else {
                return
            }

            if existingMovie == nil  {

                guard let item = NSEntityDescription.insertNewObject(forEntityName: "RMovie", into: context) as? RMovie else {
                    let error = NSError(domain: self.kDomain,
                                        code: DataController.Errors.insertError.rawValue,
                                        userInfo: ["localizedDescription": "Couldn't insert entity type RMovie to the DB"])

                    DDLogError("Couldn't insert entity type Tip to the DB")
                    completion(error)
                    return
                }

                item.movieID = movieID

                self.save()

            }

            completion(error)
        }

    }

    private func remove(movieID: String, completion: @escaping ((NSError?) -> Void)) {

        let context = DataController.shared.persistentContainer.viewContext

        context.perform {

            self.get(movie: movieID) { movie, error in

                if let movie = movie {
                    context.delete(movie)
                    self.save()
                    completion(nil)
                } else {
                    DDLogError("Error when removing id \(movieID)")
                    completion(error)
                }

            }

        }

    }

    // MARK: - Helpers -

    @objc
    func save() {

        let context = DataController.shared.persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                DDLogError("Failed to save context \(error.localizedDescription)")
            }
        } else {
            DDLogInfo("No Changes to save within context.")
        }

    }

    // MARK: - DEBUG Helpers -
    func applicationDocumentsDirectory() -> String? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            return url.absoluteString
        }

        return nil
    }
}
