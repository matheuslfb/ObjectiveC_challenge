//
//  MovieCell.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/18/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "MovieCell.h"
#import "Movie.h"
#import "Network.h"
@implementation MovieCell

NSString *baseURL = @"https://image.tmdb.org/t/p/w500";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.poster.layer.cornerRadius = 10;
    self.poster.clipsToBounds = YES;
    
}

-(void) configureWithMovie: (Movie*) movie {
    self.title.text = movie.title;
    self.overview.text = movie.overview;
    self.rating.text = movie.rating.stringValue;
    
    NSString *imagePath = [NSString stringWithFormat: @"%@%@", baseURL, movie.imageUrl];
    UIImage *posterImage = [Network.sharedNetworkInstance getLocalImage:imagePath];
    
    if (posterImage != nil) {
        self.poster.image = posterImage;
    } else {
        [Network.sharedNetworkInstance getImageFromUrl: imagePath completion:^(UIImage * _Nonnull image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.poster.image = image;
            });
        }];
    }
}

@end
