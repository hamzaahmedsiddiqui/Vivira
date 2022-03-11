//
//  SearchViewController.swift
//  Vivira
//
//  Created by Hamza Khan on 10/03/2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    @IBOutlet weak var searchBar:UISearchBar!
    
    private let searchBarPlaceholder = "Search repository ..."
    private let reuseIdentifier = "RepositoryTableViewCell"
   
    
    lazy private var viewModel : SearchViewModel = {
        let service = SearchServiceImplementation()
        let viewModel = SearchViewModelImplementation(service: service)
        return viewModel
    }()
    var repositoryArray:[Item] = []
    var activityIndicator = UIActivityIndicatorView(style: .large)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

extension SearchViewController{
    
    private func setUp(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

    private func getSearchData(searchText:String, pageNo:Int) {
        viewModel.didUpdateSearchResult(searchText: searchText, pageNo: pageNo) {[weak self] result in
            
            switch result {
            case .success(_):
                
                self?.repositoryArray = self!.viewModel.getRepositoryArray()
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                break
            case .failure(let error):
                //show alert here
                self?.showAlert(title: "Error", message: "Unable to search repository")
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText != "" else {
            self.showAlert(title: "Search field empty", message: "")
            return
        }
        activityIndicator.startAnimating()
        getSearchData(searchText: searchText, pageNo: 1)
    }
}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RepositoryTableViewCell
        let cellViewModel = self.viewModel.cellViewModelForRow(row: indexPath.row)
        cell.cellViewModel = cellViewModel
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
