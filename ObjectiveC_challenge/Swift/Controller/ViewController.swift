//
//  ViewController.swift
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/24/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var datasource: UITableViewDiffableDataSource<moviesCategoryType, Movie>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSearchController()
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a movie"
        
        //remove fade effect from collection view
        //searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        UINavigationBar.appearance().tintColor = .systemGreen
        
    }

    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ViewController:  UISearchBarDelegate {
    
}
