//
//  HomeView.swift
//  Currency tracker
//
//  Created by Slobodianiuk Oleksandr on 21.04.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showingAddAssetSheet = false
    
    init(viewModel: @autoclosure @escaping () -> HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Exchange Rates")
                .toolbar { addButton }
                .sheet(isPresented: $showingAddAssetSheet,
                       onDismiss: viewModel.reloadSelectedAssets) {
                    AddAssetView()
                }
                .onAppear(perform: viewModel.startAutoRefresh)
                .onDisappear(perform: viewModel.stopAutoRefresh)
                .onChange(of: viewModel.currentRates) {
                    viewModel.errorMessage = nil
                }        }
    }
}

// MARK: - Sub‑views
private extension HomeView {
    
    var content: some View {
        List {
            ForEach(viewModel.selectedAssets) { asset in
                AssetRowView(
                    asset: asset,
                    rate: viewModel.formatRate(for: asset.symbol),
                    percentChange: viewModel.percentChange(for: asset.symbol)
                )
                .listRowSeparator(.hidden)
                .padding(.vertical, 4)
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
        .refreshable { viewModel.refreshRates() }
        .overlay { overlayView }
        .animation(.default, value: viewModel.selectedAssets)
    }
    
    var overlayView: some View {
        Group {
            if viewModel.isLoading && viewModel.selectedAssets.isEmpty {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var addButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { showingAddAssetSheet = true } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets
            .map { viewModel.selectedAssets[$0] }
            .forEach(viewModel.removeAsset)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
