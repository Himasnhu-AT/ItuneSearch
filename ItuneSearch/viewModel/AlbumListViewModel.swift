//
//  AlbumListViewModel.swift
//  ItuneSearch
//
//  Created by Himanshu on 7/20/24.
//

import Foundation
import Combine

// https://itunes.apple.com/search?term=jack+johnson&entity=album&limit=5
// https://itunes.apple.com/search?term=jack+johnson&entity=song
// https://itunes.apple.com/search?term=jack+johnson&entity=movie

class AlbumListViewModel: ObservableObject {
    
    @Published var searchTerm: String =  ""
    @Published var albums: [Album] = [Album]()
    
    let limit: Int = 5
    
    var subscription = Set<AnyCancellable>()
    
    init () {
        
        $searchTerm
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
            self?.fetchAlbums(for: term)
        }.store(in: &subscription)
    }

    func fetchAlbums(for searchTerm: String) {
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
                
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                
                do {
                    let  result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    DispatchQueue.main.async {
                        self.albums = result.results
                    }
                    
                } catch {
                    print("decoding error \(error.localizedDescription)")
                }
                    
            }
        }.resume()
    }
}
