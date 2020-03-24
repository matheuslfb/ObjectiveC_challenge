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
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [Network.sharedNetworkInstance fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        NSLog(@"---- did load popular");
        self->_popularMovies = movies;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
    [Network.sharedNetworkInstance fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        NSLog(@"---- did now playing");
        self->_nowPlayingMovies = movies;
        dispatch_group_leave(group);
        
    }];
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"---- did reload table");
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
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

@end
