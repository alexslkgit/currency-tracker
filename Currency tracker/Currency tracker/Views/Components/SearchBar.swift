//
//  SearchBar.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

// MARK: - SearchBar

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search assets", text: $text)
                .disableAutocorrection(true)
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .foregroundColor(.gray)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
