//
//  MockSearchService.swift
//  ViviraTests
//
//  Created by Hamza Khan on 11/03/2022.
//

import Foundation
@testable import Vivira

final class MockSearchService: SearchService {
    private static let delay = 1
    func fetchSearchData(searchText: String, pageNo: Int, completionHandler: @escaping (Result<RepositoryModel, Error>) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(MockSearchService.delay)) {
            let filePath = "MockSearchResult"
            MockSearchService.loadJsonDataFromFile(filePath, completion: { (success , message , data) in
                if let json = data {
                    do {
                        let data = try JSONDecoder().decode(RepositoryModel.self, from: json)
                        
                        completionHandler(.success(data))
                    }
                    catch _ as NSError {
                        fatalError("Couldn't load data from \(filePath)")
                        
                    }
                }
            })
        }
    }
    
  
    
    private static func loadJsonDataFromFile(_ path: String, completion: (_ success : Bool , _ message : String , _ data : Data?) -> Void) {
        if let fileUrl = Bundle(for: MockSearchService.self).url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(true, "",data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(false, "",nil)
            }
        }
    }

}
