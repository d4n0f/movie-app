import Foundation
import InjectPropertyWrapper

protocol TVListViewModelProtocol: ObservableObject {
    var tvSeries: [TV] { get }
    func loadTVSeries(by genreId: Int) async
}

class TVListViewModel: TVListViewModelProtocol, ErrorViewModelProtocol {
    @Published var tvSeries: [TV] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func loadTVSeries(by genreId: Int) async {

        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let tvSeries = try await service.fetchTVSeries(req: request)
            DispatchQueue.main.async {
                self.tvSeries = tvSeries
            }
        } catch {
            print(" Error fetching TV series: \(error)")
        }
    }
}
