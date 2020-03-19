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
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovie;


@end



@implementation MainViewController

NSString *cellID = @"CellID";

NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
NSCache<NSString*, UIImage *> *cache;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    network = [[Network alloc] init];
    
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popularMovies = [self->network fetchPopularMovies];
        self.nowPlayingMovie = [self->network fetchNowPlaying];
        
        [self.mainTableView reloadData];
        
    });
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)showDetails:(id)sender {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    //        DetailsViewController * detail = [storyboard instantiateInitialViewController];
    //
    //
    //        [self showViewController:detail sender:self];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_popularMovies = [self->network fetchPopularMovies];
        self->_nowPlayingMovie = [self->network fetchPopularMovies];
        
        [self.mainTableView reloadData];
        //
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Popular";
    } else if (section == 1) {
        return @"Now Playing";
    }
    
    return @"kkk";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.popularMovies count];
    } else if (section == 1) {
        return [self.nowPlayingMovie count];
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    DetailsViewController * detail = [storyboard instantiateInitialViewController];
    
    
    [self showViewController:detail sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Movie *movie = self.popularMovies[indexPath.row];
        
        if (movie != nil) {
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            // MARK: FALTA O POSTER.IMAGE PQ N TINHA A URL :D
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
        
        Movie *movie = self.nowPlayingMovie[indexPath.row];
        
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
