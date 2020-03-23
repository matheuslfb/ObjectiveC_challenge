//
//  DetailsViewController.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/16/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "DetailsViewController.h"
#import <UIKit/UIKit.h>
//#import "Network.h"
@interface DetailsViewController () {
    UIImage *image;
    Network *sharedNetwork ;
}

@end

@implementation DetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPosterImageView];
    [self configureWithMovie:self.movie];
    
    sharedNetwork = [Network sharedNetworkInstance];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Movie Details";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}

- (void) setupPosterImageView {
    self.posterImageView.layer.cornerRadius = 10;
    self.posterImageView.clipsToBounds = YES;
}


- (void) configureWithMovie: (Movie *)movieDetail {
    self.titleMovie.text = movieDetail.title;
    self.overviewTextView.text = movieDetail.overview;
    self.ratingLabel.text = movieDetail.rating.stringValue;
    self.imageURL = movieDetail.imageUrl;
    
    
    ///Load genre list
    NSMutableString* concatGenres = NSMutableString.new;
    [Network.sharedNetworkInstance fetchMovieDetails:movieDetail.movieID completion:^(Movie * movieDetails) {
        for (NSString *genre in movieDetails.genrerList) {
            [concatGenres appendFormat:@"%@, ", genre];
        }
    }];
    
    /// Loads cover
    NSMutableString *baseImageUrl = [NSMutableString stringWithString:@"https://image.tmdb.org/t/p/w185"];
    NSString *imagePath = [baseImageUrl stringByAppendingString:self.imageURL];
    
    
    UIImage *posterImage = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
    
    if(posterImage == nil){
        [Network.sharedNetworkInstance getImageFromUrl: imagePath completion:^(NSData * _Nonnull data) {
            [self->sharedNetwork.cache setObject:data forKey:imagePath];
            self->image = [UIImage imageWithData:data];
        }];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.posterImageView.image = [UIImage imageWithData:[self->sharedNetwork.cache objectForKey:imagePath]];
        self.genderListLabel.text = concatGenres;
    });
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
