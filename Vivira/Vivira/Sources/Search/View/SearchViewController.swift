//
//  SearchViewController.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//

import UIKit
// MARK: - SearchViewController
/**
 Note: SearchViewController is now very basic. It could have been way much better in terms of design if given time.
 */
class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            let nib = UINib(nibName: Constant.RepositoryTableCellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constant.RepositoryTableCellIdentifier)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy private var viewModel : SearchViewModel = {
        let service = SearchServiceImplementation()
        let viewModel = SearchViewModelImplementation(service: service)
        return viewModel
    }()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var totalPages = 1
    private var currentPage = 1
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
// MARK: - SearchViewController-functions

extension SearchViewController{
    
    private func setUp(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    private func getSearchData(searchText:String, pageNo:Int) {
        activityIndicator.startAnimating()
      
        viewModel.didUpdateSearchResult(searchText: searchText, pageNo: pageNo) {[weak self] result in
            switch result {
            case .success(_):
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                break
            case .failure(let error):
              self?.showAlert(title: "Error", message: error.localizedDescription)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText != "" else {
            self.showAlert(title: "Error", message: "Search field empty")
            return
        }
        if Reachability.isConnectedToNetwork(){
            /*
             Internet Connection Available!
             */
            currentPage = 1
            getSearchData(searchText: searchText, pageNo: currentPage)
            self.searchText = searchText
        }else{
            /*
             Internet Connection Not Available!
             */
            self.showAlert(title: "Error", message: "Internet Connection not Available!")
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.viewModel.getRepositoryArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.RepositoryTableCellIdentifier, for: indexPath) as! RepositoryTableViewCell
        let cellViewModel = self.viewModel.cellViewModel(for: indexPath.row)
        cell.cellViewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if indexPath.row == viewModel.getRepositoryArray().count - 1{
            totalPages = viewModel.getPageCount()
            if currentPage != totalPages
            {
                currentPage += 1
                getSearchData(searchText: searchText, pageNo: currentPage)
                
            }
        }
    }
}
