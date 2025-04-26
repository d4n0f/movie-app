import SwiftUI
import InjectPropertyWrapper

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 12) {
                    Image(.icSearch)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    
                    TextField("search.textfield.placeholder",
                            text: $viewModel.searchText,
                            prompt: Text("search.textfield.placeholder")
                                .foregroundStyle(.invertedMain)
                              )
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.searchText)
                        .foregroundColor(.invertedMain)
                        .onChange(of: viewModel.searchText) {
                            Task {
                                await viewModel.searchMovies()
                            }
                        }
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(Color.searchBarForeground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(.invertedMain, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.maxPadding)
                
                if viewModel.movies.isEmpty {
                    // Üres állapot
                    VStack {
                        Spacer()
                        Text("search.empty.title")
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: LayoutConst.normalPadding) {
                            ForEach(viewModel.movies) { movie in
                                MovieCellView(movie: movie)
                                    .frame(height: 277)
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark) // Hogy jobban látszódjon a fehér szöveg
} 
