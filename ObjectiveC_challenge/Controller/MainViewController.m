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
    self.mainTableView.separatorColor = [UIColor clearColor];
    
    network = [[Network alloc] init];
    
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popularMovies = [self->network fetchPopularMovies];
        self.nowPlayingMovies = [self->network fetchNowPlaying];
        
        [self.mainTableView reloadData];
        
    });
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mainTableView reloadData];
//    });

//}

- (IBAction)showDetails:(id)sender {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    //        DetailsViewController * detail = [storyboard instantiateInitialViewController];
    //
    //
    //        [self showViewController:detail sender:self];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_popularMovies = [self->network fetchPopularMovies];
        self->_nowPlayingMovies = [self->network fetchPopularMovies];
        
        [self.mainTableView reloadData];
        //
    });
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}





- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Popular";
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
        case 0: return self.popularMovies.count;
        case 1: return self.nowPlayingMovies.count;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSMutableArray *selectedMovieArray;
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
    
    [movieDetail configureWithMovie: self.selectedMovie];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Movie *movie = self.popularMovies[indexPath.row];
        
        if (movie != nil) {
//            cell.separatorInset = UIEdgeInsetsMake(CGFLOAT_MAX, 0, 0, CGFLOAT_MAX);
            
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            //            dispatch_async(dispatch_get_main_queue(), ^{
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
            //            });
            
        }
        
    } else if (indexPath.section == 1) {
        
        Movie *movie = self.nowPlayingMovies[indexPath.row];
        
        if (movie != nil) {
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            
            // image
            //        NSLog(movie.imageUrl);
            
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
            
            
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                // https://image.tmdb.org/t/p/w500/
            //                NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
            //                NSString *imagePath = [NSString stringWithFormat: @"%@%@", baseURL, movie.imageUrl];
            //
            //                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imagePath]];
            //                cell.poster.image = [UIImage imageWithData: imageData];
            //            });
        }
    }
    
    return cell;
}



- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}


@end
