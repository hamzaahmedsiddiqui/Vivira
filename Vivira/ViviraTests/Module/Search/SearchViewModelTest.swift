//
//  SearchViewModelTest.swift
//  ViviraTests
//
//  Created by Hamza Khan on 11/03/2022.
//

import XCTest
@testable import Vivira

class SearchViewModelTest: XCTestCase {
    var mockSearchService : MockSearchService!
    var viewModel : SearchViewModel!
    
    override func setUpWithError() throws {
        setupViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockSearchService = nil
        
    }
    private func setupViewModel(){
        mockSearchService = MockSearchService()
        guard let mockSearchService = mockSearchService else {
            XCTFail("ViewModel cannot be instantiated.")
            return }
        viewModel = SearchViewModelImplementation(service: mockSearchService)
    }
 

    func testCellViewModelForRow(){
        let expectation = self.expectation(description: "should recieve data")
        
        viewModel.didUpdateSearchResult(searchText: "hamzaahmedsiddiqui", pageNo: 1) { [weak self] result in
            guard let self = self else {
                XCTFail()
                return
            }
            switch result {
            case .success(_):
                XCTAssertNotNil(self.viewModel.getRepositoryArray)
                expectation.fulfill()
                
            case .failure(_):
                XCTFail("service failed")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testServiceCall()  {
        let expectation = self.expectation(description: "should recieve data")
        viewModel.didUpdateSearchResult(searchText: "Berlin", pageNo: 1) { [weak self] result in
            guard self != nil else {
                XCTFail()
                return
            }
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("service failed")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
