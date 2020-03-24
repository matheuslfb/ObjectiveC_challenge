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
    
    self.searchBar.delegate = self;
    
    sharedNetwork = [Network sharedNetworkInstance];
    
    [self fetchMovies];
    
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Popular Movies";
        case 1: return @"Now Playing";
    }
    
    return @"";
}

-(void) fetchMoreNowPlayingMovies{
    [Network.sharedNetworkInstance fetchNowPlayingMoviesByPage: self.page completion:^(NSMutableArray * _Nonnull movies) {
        NSLog(@"---- did fetch more now playing");
        [ self->_nowPlayingMovies addObjectsFromArray: movies] ;
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
    switch (section) {
        case 0: return 2;
        case 1: return self.nowPlayingMovies.count;
            
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            [cell configureWithMovie:movie];
        }
    } else if (indexPath.section == 1) {
        Movie *movie = self.nowPlayingMovies[indexPath.row];
        
        if (movie != nil) {
            [cell configureWithMovie:movie];
        }
    }
    
    return cell;
}

- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

@end
