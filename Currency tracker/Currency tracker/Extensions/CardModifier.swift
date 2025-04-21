//
//  CardModifier.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

// MARK: - View Modifiers & Extensions

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
            )
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardModifier()) }
}

extension String {
    var percentChangeColor: Color {
        hasPrefix("+") ? .green : hasPrefix("-") ? .red : .gray
    }
}
