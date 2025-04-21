//
//  SectionHeader.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

// MARK: - SectionHeader

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundColor(.gray)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
}
