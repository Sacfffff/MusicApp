//
//  SearchViewModel.swift
//  MusicApp2
//
//  Created by Aleks Kravtsova on 8.07.22.
//

import Foundation

protocol SearchViewModelProtocol {
    var categories : [Category] {get}
    var update : (() -> Void)? {get set}
    var setup : (([SearchResult]) -> Void)? {get set}
    func fetchDataForCategoriesSearch()
    func search(with query: String)
}

final class SearchViewModel  : SearchViewModelProtocol {
    private let fetchServiceCategory : FetchDataServiceCategory = FetchDataServiceCategory()
    private let fetchServiceSearch : FetchDataServiceSearch = FetchDataServiceSearch()
    
    
    var categories: [Category] = [] {
        didSet {
            update?()
        }
    }
    
    var setup: (([SearchResult]) -> Void)?
    
    var update: (() -> Void)?
    
    func fetchDataForCategoriesSearch() {
        fetchServiceCategory.fetchDataForCategories { [weak self] model, error in
            DispatchQueue.main.async {
                if error == nil, let categories = model {
                    self?.categories = categories
                } else {print(error!.localizedDescription)}
                
            }
        }
    }
   
    func search(with query: String) {
        fetchServiceSearch.fetchDataForSearch(with: query) { [weak self] results, error in
            DispatchQueue.main.async {
                if error == nil, let results = results,let setup = self?.setup {
                 setup(results)
                } else {print(error!.localizedDescription)}
                
            }
        }

    }
    
}
