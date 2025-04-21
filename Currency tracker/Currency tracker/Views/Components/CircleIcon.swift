//
//  CircleIcon.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

// MARK: - CircleIcon

struct CircleIcon: View {
    let asset: Asset
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(asset.category.color)
            .frame(width: size, height: size)
            .overlay(
                Text(String(asset.symbol.prefix(1)))
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
            )
    }
}
