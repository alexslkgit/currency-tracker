//
//  AssetRowView.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

struct AssetRowView: View {
    
    private enum Constants {
        static let iconSize: CGFloat   = 40
        static let verticalPadding: CGFloat = 15
        static let horizontalPadding: CGFloat = 12
    }
    
    let asset: Asset
    let rate: String
    let percentChange: String
    
    var body: some View {
        HStack {
            CircleIcon(asset: asset, size: Constants.iconSize)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.symbol).font(.headline)
                Text(asset.name).font(.subheadline).foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(rate).font(.headline).monospacedDigit()
                
                if !percentChange.isEmpty {
                    Text(percentChange)
                        .font(.subheadline)
                        .foregroundColor(percentChange.percentChangeColor)
                }
            }
        }
        .padding(.vertical, Constants.verticalPadding)
        .padding(.horizontal, Constants.horizontalPadding)
        .cardStyle()
        .padding(.vertical, 4)
    }
}
