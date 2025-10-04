//
//  AddReviewView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 30..
//

import SwiftUI

struct AddReviewView: View {
    
    let mediaItemDetail: MediaItemDetail
    
    @StateObject private var viewModel = AddReviewViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                MediaItemHeaderView(title: viewModel.mediaItemDetail.title,
                                    year: viewModel.mediaItemDetail.year,
                                    runtime: "\(viewModel.mediaItemDetail.runtime)",
                                    spokenLanguages: viewModel.mediaItemDetail.spokenLanguages)
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(height: 185)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(30)
                Text("addReview.subTitle".localized())
                    .font(Fonts.detailsTitle)
                HStack {
                    Spacer()
                    VStack (spacing: 72.0){
                        StarRatingView(rating: $viewModel.selectedRating, onTap: { rating in
                            viewModel.selectedRating = rating
                        })
                        StyledButton(style: .filled, action: .simple, title: "add.review.submit.button".localized())
                            .onTapGesture {
                                viewModel.sendReviewSubject.send(())
                            }
                    }
                    .padding(.bottom, 24.0)
                    Spacer()
                }
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, LayoutConst.maxPadding)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaDetailSubject.send(mediaItemDetail)
        }
        .onChange(of: viewModel.success) {
            dismiss()
        }
    }
}
