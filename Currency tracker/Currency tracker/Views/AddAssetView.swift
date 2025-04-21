//
//  AddAssetView.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

struct AddAssetView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddAssetViewModel
    
    init(viewModel: @autoclosure @escaping () -> AddAssetViewModel = AddAssetViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(assetSections, id: \.title) { section in
                            if !section.assets.isEmpty {
                                SectionHeader(title: section.title)
                                ForEach(section.assets) { asset in
                                    AssetSelectionRowView(
                                        asset: asset,
                                        isSelected: viewModel.isAssetSelected(asset)
                                    ) {
                                        viewModel.toggleAssetSelection(asset)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
                .overlay { loadingOverlay }
            }
            .navigationTitle("Add Asset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
    }
    
    // MARK: - Sections
    private var assetSections: [(title: String, assets: [Asset])] {
        [
            ("POPULAR ASSETS", viewModel.popularAssets),
            ("CRYPTOCURRENCIES", viewModel.cryptoAssets),
            ("OTHER CURRENCIES", viewModel.otherAssets)
        ]
    }
    
    // MARK: - Overlays & Toolbar
    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if let error = viewModel.errorMessage {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            Button("Cancel", action: dismiss.callAsFunction)
        }
        return ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button("Done", action: dismiss.callAsFunction).bold()
        }
    }
}
