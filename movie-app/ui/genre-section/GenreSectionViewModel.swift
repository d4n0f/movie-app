import Foundation
import InjectPropertyWrapper

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ? try await movieService.fetchTVGenres(req: request) :
                                                    try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch let error as MovieError{
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
    
    private func toAlertModel(_ error: MovieError) -> AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "error.dismissButton.title"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "API Error",
                message: message,
                dismissButtonTitle: "error.dismissButton.title"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "error.dismissButton.title"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "error.dismissButton.title"
            )
        }
    }
}

