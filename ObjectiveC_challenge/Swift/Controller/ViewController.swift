//
//  ViewController.swift
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/24/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var popularMovies: [Movie] = []
    var nowPlaying: [Movie] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(MovieCell.self, forCellReuseIdentifier: "CellID")
        
        configureSearchController()
        fetchMovies()
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a movie"
        
        //remove fade effect from collection view
        searchController.obscuresBackgroundDuringPresentation = true
        
        navigationItem.searchController = searchController
    }
    
    func fetchMovies() {
        
        guard let network = Network.sharedNetworkInstance() as? Network else { return }
        
        network.fetchMovies(POPULAR) { (movies) in
            print("------- fetch pop")
            self.popularMovies = movies as! [Movie]
            DispatchQueue.main.async {
                print("------- reload 1")
                self.tableView.reloadData()
            }
        }
        
        network.fetchMovies(NOW_PLAYING) { (movies) in
            print("------- fetch now")
            self.nowPlaying = movies as! [Movie]
            
            DispatchQueue.main.async {
                print("------- reload 2")
                self.tableView.reloadData()
            }
        }
        
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return nowPlaying.count
        default:
            0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? MovieCell else { return UITableViewCell()}
        
//        guard let cell = (UITableViewCell.init(style: ., reuseIdentifier: "CellID")) as? MovieCell else { return UITableViewCell() }
//        let cell = createCell()
        var movie = Movie()
        
        if indexPath.section == 0 {
            movie = self.popularMovies[indexPath.row]
            cell.title?.text = movie.title
        } else if indexPath.section == 1 {
            movie = self.nowPlaying[indexPath.row]
            cell.title?.text = movie.title
        }
        
     
        
//        cell.configure(with: movie)
        return cell
    }
    
    @objc func createCell() -> MovieCell {
        let cell = MovieCell()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Popular Movies"
        case 1:
            return "Now Playing"
        default:
            ""
        }
        return ""
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ViewController:  UISearchBarDelegate {
    
}
