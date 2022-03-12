//
//  RepositoryTableCellViewModel.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//

import Foundation


struct RepositoryTableCellViewModel{
    
    let repository: Item
    func getImageLink()->URL {
        
        return URL(string: repository.owner!.avatarURL!)!
    }
    
    func getOwnerName()-> String {
        return repository.owner!.login ?? ""
        
    }
    
    func getRepositoryName()->String {
        return repository.name ?? ""
    }
    
    func getRepositoryTitle()->String {
        return repository.fullName ?? ""
    }
    
    func getRepositoryDescription()->String {
        return repository.itemDescription ?? ""
        
    }
    
    func getRepositoryLink()->String{
        return repository.htmlURL ?? ""
    }
}
