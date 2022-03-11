//
//  SearchViewControllerTest.swift
//  ViviraTests
//
//  Created by Hamza Khan on 11/03/2022.
//

import XCTest
@testable import Vivira

class SearchViewControllerTest: XCTestCase {
    var sut:SearchViewController!
    var viewModel:SearchViewModel!
    var mockSearchService:MockSearchService!
    

    override func setUpWithError() throws {
        setupViewController()
        setupViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
    private func setupViewController(){
        let storyboard = UIStoryboard(name: Constant.storyboardIdentifier, bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        guard let vc : SearchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else{
            return XCTFail("Could not instantiate SearchViewController")
        }
        sut = vc
        UIApplication.shared.windows.first{ $0.isKeyWindow }!.rootViewController = UINavigationController.init(rootViewController: vc)
        sut.loadViewIfNeeded()
    }
    private func setupViewModel(){
        mockSearchService = MockSearchService()
        guard let mockSearchService = mockSearchService else {
            XCTFail("ViewModel cannot be instantiated.")
            return }
        viewModel = SearchViewModelImplementation(service: mockSearchService)
    }

}
extension SearchViewControllerTest{
    func testTableViewExist(){
        XCTAssertNotNil(sut.tableView, "Controller should have a table view")

    }
    func testTableViewDelegateSetUpCorrectly() {
        XCTAssertTrue(sut.tableView.delegate is SearchViewController , "SearchViewController does not conform to tableView delegate protocol")
    }
    func testSearchBarExist(){
        XCTAssertNotNil(sut.searchBar, "Controller should have a search bar")
    }
    func testSearchBarDelegateSetUpCorrectly() {
        XCTAssertTrue(sut.searchBar.delegate is SearchViewController , "SearchViewController does not conform to searchBar delegate protocol")
    }
    
}
