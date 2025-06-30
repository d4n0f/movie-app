//
//  StarView.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 06. 30..
//

import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    let onTap: () -> Void

    var body: some View {
        Image(isFilled ? .starFilled : .starUnfilled)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40.0, height: 40.0)
            .onTapGesture {
                onTap()
            }
    }
}
