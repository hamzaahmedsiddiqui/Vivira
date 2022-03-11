//
//  SearchRepositoryViewModel.swift
//  Vivira
//
//  Created by Hamza Khan on 10/03/2022.
//

import Foundation
import AVFoundation

protocol SearchViewModel{
    
    func didUpdateSearchResult(searchText:String, pageNo:Int, completionHandler:@escaping (Swift.Result<Bool, Error>)->Void)
    func getRepositoryArray() -> [Item]
    func getItemCount()-> Int
    func getPageCount()-> Int
    func cellViewModelForRow(row: Int)-> RepositoryTableCellViewModel
}


class SearchViewModelImplementation:SearchViewModel{
    let service: SearchService
    var repositoryArray:[Item] = []
    var totalItems:Int = 0
    let itemsPerPage = 30
    private var lastSearchText: String = ""


    init(service : SearchService) {
        self.service = service
    }
    
    func didUpdateSearchResult(searchText:String, pageNo:Int, completionHandler:@escaping (Swift.Result<Bool, Error>)->Void){
        lastSearchText = searchText
        service.fetchSearchData(searchText: lastSearchText, pageNo: pageNo) {  [unowned self] result in
            
            switch result {
            case .success(let data):
                self.repositoryArray = data.items!
                self.totalItems = data.totalCount ?? 0
                
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
    }
    
    func getRepositoryArray() -> [Item]{
        return repositoryArray
    }
    
    func getItemCount()-> Int{
        return totalItems
    }
    
    func getPageCount()-> Int{
        if totalItems >= itemsPerPage {
            return totalItems/itemsPerPage
        }
        
        return 1
       
    }
    func cellViewModelForRow(row: Int)-> RepositoryTableCellViewModel {
        let repository = repositoryArray[row]
        return RepositoryTableCellViewModel(repository: repository)
    }
}
