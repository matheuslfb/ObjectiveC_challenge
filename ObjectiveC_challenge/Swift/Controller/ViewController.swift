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
    var filteredMovies : [Movie] = []
    var selectedMovie = Movie()
    var hasMoreMovies = false
    var page = 1
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        fetchMovies()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    
    func configureViewController() {
        navigationController?.navigationBar.tintColor = .systemGreen
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .clear
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a movie"
        
        //remove fade effect from table view
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    func fetchMovies() {
        
        guard let network = Network.sharedNetworkInstance() as? Network else { return }
        
        let group = DispatchGroup()
        
        group.enter()
        network.fetchMovies(POPULAR) { (movies) in
            print("------- fetch pop")
            self.popularMovies = movies as! [Movie]
            group.leave()
        }
        
        group.enter()
        network.fetchMovies(NOW_PLAYING) { (movies) in
            print("------- fetch now")
            self.nowPlaying = movies as! [Movie]
            group.leave()
        }
        
        group.wait()
        DispatchQueue.main.async {
            print("------- reload 1")
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if isFiltering {
                return filteredMovies.count
            } else {
                return 2
            }
        case 1:
            return nowPlaying.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? MovieCell else { return UITableViewCell()}
        
        var movie = Movie()
        
        if indexPath.section == 0 {
            if(isFiltering){
                movie = self.filteredMovies[indexPath.row]
            } else {
                movie = self.popularMovies[indexPath.row]
            }
            
        } else if indexPath.section == 1 {
            movie = self.nowPlaying[indexPath.row]
        }
        
        cell.configure(with: movie)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering{
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if isFiltering{
                return ""
            } else {
                return "Popular Movies"
            }
        case 1:
            return "Now Playing"
        default:
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            if isFiltering {
                self.selectedMovie = self.filteredMovies[indexPath.row]
            } else {
                self.selectedMovie = self.popularMovies[indexPath.row]
            }
            
        } else if indexPath.section == 1 {
            self.selectedMovie = self.nowPlaying[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailsViewController else { return }
        vc.movie = selectedMovie
        
//       guard let indexPath = tableView.indexPathForSelectedRow else { return }
//
//        var movie  = self.popularMovies[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemBackground
        
        let header = UITableViewHeaderFooterView()
        header.textLabel?.tintColor = .black
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let maximumOffSet = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (!hasMoreMovies && (maximumOffSet - offSetY <= 20)){
            hasMoreMovies = true
            self.page += 1
            
            guard let network = Network.sharedNetworkInstance() as? Network else { return }
            
            network.fetchNowPlayingMovies(byPage: Int32(self.page)) { (newMovies) in
                self.nowPlaying.append(contentsOf: newMovies as! [Movie])
                self.hasMoreMovies = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar
        filterContentFolSearchText(search.text!)
    }
    
    func filterContentFolSearchText(_ searchText: String) {
        filteredMovies = nowPlaying.filter{
            $0.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension ViewController:  UISearchBarDelegate {
    
}
