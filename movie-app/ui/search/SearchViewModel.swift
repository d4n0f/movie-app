import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
    var searchText: String { get set }
    func searchMovies() async
    func setupDebounce()
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""

    @Inject
    private var service: MoviesServiceProtocol

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupDebounce()
    }

    func searchMovies() async {
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }

        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error searching movies: \(error)")
        }
    }
    
    func setupDebounce() {
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newText in
                Task {
                    await self?.searchMovies()
                }
            }
            .store(in: &cancellables)
    }
}
