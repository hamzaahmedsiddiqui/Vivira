//
//  SearchRepositoryViewModel.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//

import Foundation
import AVFoundation
// MARK: - SearchViewModel
protocol SearchViewModel{
    
    func didUpdateSearchResult(searchText:String, pageNo:Int, completionHandler:@escaping (Swift.Result<Bool, Error>)->Void)
    func getRepositoryArray() -> [Item]
    func getPageCount()-> Int
    func cellViewModelForRow(row: Int)-> RepositoryTableCellViewModel
    func getRepositoryArrayCount()-> Int
}

// MARK: - SearchViewModelImplementation
class SearchViewModelImplementation:SearchViewModel {
    let service: SearchService
    var repositoryArray:[Item] = []
    var totalItems = 0
    let itemsPerPage = 30
    private var lastSearchText: String = ""
    
    init(service : SearchService) {
        self.service = service
    }
    
    func didUpdateSearchResult(searchText:String, pageNo:Int, completionHandler:@escaping (Swift.Result<Bool, Error>)->Void){
        
        
        service.fetchSearchData(searchText: searchText, pageNo: pageNo) {  [unowned self] result in
            
            switch result {
            case .success(let data):
                if  lastSearchText == searchText && pageNo > 1
                {
                    self.repositoryArray.append(contentsOf: data.items!)
                }else{
                    self.lastSearchText = searchText
                    self.repositoryArray = data.items!
                    self.totalItems = data.totalCount ?? 0
                }
                
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    func getRepositoryArray() -> [Item] {
        return repositoryArray
    }
    
    func getPageCount()-> Int {
        if totalItems > itemsPerPage {
            if totalItems % itemsPerPage == 0 {
                return totalItems/itemsPerPage
            }
            
            return totalItems/itemsPerPage + 1
        }
        return 1
    }
    
    func cellViewModelForRow(row: Int)-> RepositoryTableCellViewModel {
        let repository = repositoryArray[row]
        return RepositoryTableCellViewModel(repository: repository)
    }
    
    func getRepositoryArrayCount()-> Int {
        return repositoryArray.count
    }
}
