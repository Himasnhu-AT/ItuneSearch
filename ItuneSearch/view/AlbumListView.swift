//
//  AlbumListView.swift
//  ItuneSearch
//
//  Created by Himanshu on 7/20/24.
//

import SwiftUI

struct AlbumListView: View {
    
    
    @StateObject var viewModel = AlbumListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.albums) {album in
                Text(album.collectionName)
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchTerm)
            .navigationTitle("Search Albums")
        }
    }
}

#Preview {
    AlbumListView()
}
