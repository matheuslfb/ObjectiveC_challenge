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
    Network *network;
    
}

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;

@property (strong, nonatomic) Movie *selectedMovie;


@end



@implementation MainViewController

NSString *cellID = @"CellID";

NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
NSCache<NSString*, UIImage *> *cache;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorColor = [UIColor clearColor];
    
    network = [[Network alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    [self fetchMovies];
}

-(void) fetchMovies {
    [network fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        self->_popularMovies = movies;
    }];
    
    [network fetchMovies:NOW_PLAYING completion:^(NSMutableArray * movies) {
        self->_nowPlayingMovies = movies;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mainTableView reloadData];
        
    });
}

- (IBAction)showDetails:(id)sender {
    
    
    [network fetchMovies:POPULAR completion:^(NSMutableArray * movies) {
        self->_popularMovies = movies;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
            
        });
        
    }];
    
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
    switch (indexPath.section) {
        case 0: selectedMovieArray = self.popularMovies;
        case 1: selectedMovieArray = self.nowPlayingMovies;
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
            cache = [NSCache<NSString*, UIImage *> new];
            
            NSURL *url = [NSURL URLWithString:imagePath];
            
            UIImage *posterImage = [cache objectForKey:imagePath];
            
            if (posterImage == nil) {
                [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        return;
                    }
                    UIImage *image = [UIImage imageWithData:data];
                    [cache setObject: image forKey:imagePath];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.poster.image = [cache objectForKey:imagePath];
                    });
                }] resume];
                
            } else {
                cell.poster.image = [cache objectForKey:imagePath];
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
            cache = [NSCache<NSString*, UIImage *> new];
            
            NSURL *url = [NSURL URLWithString:imagePath];
            
            UIImage *posterImage = [cache objectForKey:imagePath];
            
            if (posterImage == nil) {
                [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        return;
                    }
                    UIImage *image = [UIImage imageWithData:data];
                    [cache setObject: image forKey:imagePath];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.poster.image = [cache objectForKey:imagePath];
                    });
                }] resume];
                
            } else {
                cell.poster.image = [cache objectForKey:imagePath];
            }
        }
    }
    
    return cell;
}


- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}


@end
