//
//  Network.h
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/18/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Network : NSObject

@property (strong, nonatomic) NSString *popular_url;
@property (strong, nonatomic) NSString *now_playing_url;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *API_KEY ;

+(id) sharedNetworkInstance;
@property (nonatomic, retain) NSCache<NSString*, UIImage *> *cache;

- (instancetype) init;

typedef enum moviesCategoryType {
    POPULAR,
    NOW_PLAYING
} moviesCategory;



- (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback;
- (void) fetchMovieDetails:(NSString* )movieId completion:(void (^)(Movie*))callback;
//- (void) getImageFromUrl: (NSString* ) imageURL completion:(void (^)(NSData*))callback;
-(void) fetchNowPlayingMoviesByPage:(NSNumber*) page completion: (void (^)(NSMutableArray*))callback;
-(UIImage*) getLocalImage:(NSString *) path;

-(void) getImageFromUrl:(NSString *)imageURL completion:(void (^)(UIImage * _Nonnull))callback;
@end

NS_ASSUME_NONNULL_END
