//
//  SearchViewController.swift
//  traktfy
//
//  Created by Rogerio Cervasio on 10/06/17.
//  Copyright © 2017 ACME. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var showArray: [Show] = []
    var page: Int = 0
    var loadingMore : Bool!
    var searchTerm : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.showsCancelButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
        if segue.identifier == "segueShowDetail" {
            
            print("SearchViewController \(#function)")
            
            let showDetailViewController = segue.destination as! ShowDetailViewController
            
            showDetailViewController.show = sender as? Show
            
        }
     
    }
 

    func getSearchResults(queryString: String, completion: ((_ finished: Bool) -> Void)? = nil) {
        
        if queryString.characters.count > 1 {
            self.loadingMore = true
            self.page += 1
            
            _ = Service.shared.getSearchedSeries(extendedOptions: "full", query: queryString, page: self.page) { (finished, show, message) in
                
                if finished && show != nil {
                    
                    if (show?.count)! > 0 {
                        
                        self.showArray.append(contentsOf: show!)
                        self.tableView.reloadData()
                        self.tableView.flashScrollIndicators()
                    }
                    
                }
//                else if !(message?.isEmpty)! {
//
//                    let alert = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)
//                    alert.addAction(
//                        UIAlertAction(title: "OK", style: .default) { [weak self] _ in
//                            self?.dismiss(animated: true, completion: nil)
//                        }
//                    )
//                    self.present(alert, animated: true)
//                }
                
                self.loadingMore = false
                
                completion?(finished)
            }

        }
        
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.showArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let show = self.showArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchSeriesCell", for: indexPath) as! SearchTableViewCell
        
        cell.labelTitle.text = show.showTitle
        cell.labelOverview.text = show.showOverview

        if (indexPath.row == self.showArray.count - 1 && !self.loadingMore) {
            if self.page == 0 {self.page = 1}
            print("SearchViewController \(#function) - getSearchResults() - page: \(self.page) - indexPath.row: \(indexPath.row) - pullArray.count: \(self.showArray.count)")
            self.getSearchResults(queryString: searchBar.text!)
        }
        
        return cell
        
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let show = self.showArray[indexPath.row]
        
        print("SearchViewController \(#function) - show.showTitle: \(String(describing: show.showTitle!)) - traktID: \(show.traktID!)")
        
        self.performSegue(withIdentifier: "segueShowDetail", sender: show)
    }

}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NSLog("The default search bar keyboard search button was tapped: \(String(describing: searchBar.text)).")
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // searchBar.resignFirstResponder()
        
        self.getSearchResults(queryString: searchBar.text!)
        
    }
}


