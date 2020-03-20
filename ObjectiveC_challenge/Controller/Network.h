//
//  Network.h
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/18/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject

@property (strong, nonatomic) NSString *popular_url;
@property (strong, nonatomic) NSString *now_playing_url;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *API_KEY ;


- (instancetype) init;

typedef enum moviesCategoryType {
    POPULAR,
    NOW_PLAYING
} moviesCategory;

- (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback;

- (void) fetchMovieDetails:(NSString* )movieId completion:(void (^)(Movie*))callback;
@end

NS_ASSUME_NONNULL_END
