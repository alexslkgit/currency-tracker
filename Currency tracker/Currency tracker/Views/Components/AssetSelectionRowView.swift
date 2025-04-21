//
//  AssetSelectionRowView.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

// MARK: - AssetSelectionRowView

struct AssetSelectionRowView: View {
    private enum Constants {
        static let iconSize: CGFloat = 36
    }
    
    let asset: Asset
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                CircleIcon(asset: asset, size: Constants.iconSize)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.symbol).font(.headline)
                    Text(asset.name).font(.subheadline).foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .cardStyle()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

