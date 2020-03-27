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
    var selectedMovie = Movie()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        fetchMovies()
        configureSearchController()
    }
    
    func configureViewController() {
        self.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .clear
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
            return 2
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
            movie = self.popularMovies[indexPath.row]
        } else if indexPath.section == 1 {
            movie = self.nowPlaying[indexPath.row]
        }
        
        cell.configure(with: movie)
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
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var movies: [Movie] = []
        if indexPath.section == 0{
            movies = self.popularMovies
        } else if indexPath.section == 1 {
            movies = self.nowPlaying
        }
        
        selectedMovie = movies[indexPath.row]
        
        
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        guard let vc =  storyboard.instantiateViewController(identifier: "detail") as? DetailsViewController else { return }
        
        print(selectedMovie.title)
        vc.configure(with: selectedMovie)
        self.show(vc, sender: nil)
        //        self.performSegue(withIdentifier: "detail", sender: nil)
        //        guard let vc = segue.destination as? DetailsViewController else { return }
        //        self.show(vc, sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailsViewController else { return }
        print(selectedMovie.title)
        vc.movie = selectedMovie
        //        vc.titleMovie?.text = selectedMovie.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemBackground
        
        let header = UITableViewHeaderFooterView()
        header.textLabel?.tintColor = .black
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ViewController:  UISearchBarDelegate {
    
}
