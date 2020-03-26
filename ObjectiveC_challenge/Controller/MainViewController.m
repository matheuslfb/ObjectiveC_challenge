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
    Network *sharedNetwork;
    
    NSMutableArray *filteredMovies;
    BOOL isFiltered;
}

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;
@property (strong, nonatomic) Movie *selectedMovie;

@property (nonatomic) int page;
@end


@implementation MainViewController

//NSNumber *page;
NSString *cellID = @"CellID";
bool hasMoreMovies = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorColor = [UIColor clearColor];
    
    /// Search
    self.searchBar.delegate = self;
    isFiltered = NO;
//    filteredMovies = NSMutableArray.new;
    
    sharedNetwork = [Network sharedNetworkInstance];
    
    [self fetchMovies];
//
//    [Network.sharedNetworkInstance fetchMovieByQuery:@"Joker" :1 completion:^(NSMutableArray * movies) {
//        NSLog(@"corona");
//    }];
    
    
    
}

-(void) fetchMovies {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [Network.sharedNetworkInstance fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        self->_popularMovies = movies;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [Network.sharedNetworkInstance fetchNowPlayingMoviesByPage: self.page completion:^(NSMutableArray * _Nonnull movies) {
        self->_nowPlayingMovies = movies;
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isFiltered) {
        return 1;
    } else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if(!isFiltered){
                return @"Popular Movies";
            } else {
                return @"";
            }
        case 1: return @"Now Playing";
    }
    
    return @"";
}

-(void) fetchMoreNowPlayingMovies{
    [Network.sharedNetworkInstance fetchNowPlayingMoviesByPage: self.page completion:^(NSMutableArray * _Nonnull movies) {
        NSLog(@"---- did fetch more now playing");
        [ self->_nowPlayingMovies addObjectsFromArray: movies];
        NSLog(@"%i", (int)self->_page);
        hasMoreMovies = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"---- did reload table");
            [self.mainTableView reloadData];
        });
    }];
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
}

///Pagination
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    
    if (!hasMoreMovies && (maximumOffset - offSetY <= 20)) {
        hasMoreMovies = YES;
        self.page +=1;
        
        self.fetchMoreNowPlayingMovies;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (isFiltered) {
//        return filteredMovies.count;
//    } else {
        switch (section) {
            case 0:
                if (isFiltered) {
                    return filteredMovies.count;
                } else {
                    return 2;
                }
            case 1:
                return self.nowPlayingMovies.count;
                
        }
//    }
    
    return 0;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<Movie*> *selectedMovieArray;
    
    if (indexPath.section == 0) {
        if (isFiltered) {
            selectedMovieArray = self->filteredMovies;
        } else {
            selectedMovieArray = self.popularMovies;
        }
    }else if (indexPath.section == 1){
        selectedMovieArray = self.nowPlayingMovies;
    }
    
    
    
    Movie *selectedMovie = selectedMovieArray[indexPath.row];
    self.selectedMovie = selectedMovie;
    
    [self performSegueWithIdentifier: @"detail" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *movieDetail = [segue destinationViewController];
    movieDetail.movie = self.selectedMovie;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    Movie *movie = Movie.new;
    
    if (indexPath.section == 0) {
        if (isFiltered && movie != nil) {
            movie = self->filteredMovies[indexPath.row];
        } else {
            movie = self.popularMovies[indexPath.row];
        }
        
        [cell configureWithMovie:movie];

    } else if (indexPath.section == 1) {
        Movie *movie = self.nowPlayingMovies[indexPath.row];
        
        if (movie != nil) {
            [cell configureWithMovie:movie];
        }
    }
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        isFiltered = NO;
        [filteredMovies removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_mainTableView reloadData];
        });
        
    } else {
        isFiltered = YES;
        filteredMovies = NSMutableArray.new;
//        NSArray *searchResult = NSArray.new;
        
        [Network.sharedNetworkInstance fetchMovieByQuery:searchText :self.page completion:^(NSMutableArray *movies) {
            
            //
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector: @selector(reload) object:nil];
            [self performSelector:@selector(reload) withObject:nil afterDelay:0.5];
            
            [self->filteredMovies addObjectsFromArray: movies];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_mainTableView reloadData];
            });
            
            NSLog(@"CORINGA: %@", self->filteredMovies);
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_mainTableView reloadData];
        });
        
    }
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isFiltered = YES;
}

@end
