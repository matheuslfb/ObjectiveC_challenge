//
//  MainViewController.m
//  ObjectiveC_challenge
//
//  Created by Ronald Maciel on 17/03/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>
#import "Network.h"
#import "Movie.h"
#import "MovieCell.h"

@interface MainViewController (){
    Network *sharedNetwork ;
}

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;

@property (strong, nonatomic) Movie *selectedMovie;


@end



@implementation MainViewController

NSNumber *page;
NSString *cellID = @"CellID";
NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
//NSCache<NSString*, UIImage *> *cache;

- (void)viewDidLoad {
    [super viewDidLoad];
    page = @1;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorColor = [UIColor clearColor];
    
    self.searchBar.delegate = self;
    
    sharedNetwork = [Network sharedNetworkInstance];
    
    [self fetchMovies];
}

-(void) fetchMovies {
    [Network.sharedNetworkInstance fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        self->_popularMovies = movies;
    }];
    
    [Network.sharedNetworkInstance fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        self->_nowPlayingMovies = movies;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Popular Movies";
        case 1: return @"Now Playing";
    }
    
    return @"";
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 2;
        case 1: return self.nowPlayingMovies.count;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap");
    NSMutableArray<Movie*> *selectedMovieArray;
    
    if (indexPath.section == 0) {
        selectedMovieArray = self.popularMovies;
    }else {
        selectedMovieArray = self.nowPlayingMovies;
    }
    
    
    
    Movie *selectedMovie = selectedMovieArray[indexPath.row];
    self.selectedMovie = selectedMovie;
    
    [self performSegueWithIdentifier:@"detail" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *movieDetail = [segue destinationViewController];
    movieDetail.movie = self.selectedMovie;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Movie *movie = self.popularMovies[indexPath.row];
        
        if (movie != nil) {
            
            
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            
            // https://image.tmdb.org/t/p/w500/
            
            NSString *imagePath = [NSString stringWithFormat: @"%@%@", baseURL, movie.imageUrl];
            
            UIImage *posterImage = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
            
            if (posterImage == nil) {
                [Network.sharedNetworkInstance getImageFromUrl:imagePath completion:^(NSData * _Nonnull data) {
                    [self->sharedNetwork.cache setObject:data forKey:imagePath];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.poster.image = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
                });
                
            } else {
                cell.poster.image = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
            }
            
            
        }
        
    } else if (indexPath.section == 1) {
        
        Movie *movie = self.nowPlayingMovies[indexPath.row];
        
        if (movie != nil) {
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            
            // image
            
            NSString *imagePath = [NSString stringWithFormat: @"%@%@", baseURL, movie.imageUrl];
            
            UIImage *posterImage = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
            
            if (posterImage == nil) {
                [Network.sharedNetworkInstance getImageFromUrl:imagePath completion:^(NSData * _Nonnull data) {
                    [self->sharedNetwork.cache setObject:data forKey:imagePath];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.poster.image = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
                });
                
            } else {
                cell.poster.image = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
            }
        }
    }
    
    return cell;
}

<<<<<<< HEAD

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row +1 == self.popularMovies.count) {
//        NSLog(@"chegou no fim");
//        int value = [page intValue];
//        page = [NSNumber numberWithInt: value+1];
//        [Network.sharedNetworkInstance fetchNowPlayingMoviesByPage:page completion:^(NSMutableArray * _Nonnull movies) {
//            [self.popularMovies addObjectsFromArray:movies];
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView reloadData];
//        });
//    }
//
//    
//}

//-(void) tableViewDidEndDraggin {
//    CGFloat offSetY = self.mainTableView.contentOffset.y;
//    CGFloat contentHeight = self.mainTableView.contentSize.height;
//    CGFloat height =  self.mainTableView.frame.size.height;
//    
//    if(offSetY > contentHeight - height) {
//        // page += 1
//        // fetchPopularMovie( page)
//    }
//}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
=======
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
>>>>>>> 008b8210c76a974dd70643448524573cf64158b0
}
@end
