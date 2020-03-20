//
//  Network.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/18/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "Network.h"

@implementation Network

//@"6af6fb6deb5f2e4c6d36e514240eeebb";
//NSString *API_KEY =


- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.now_playing_url = @"https://api.themoviedb.org/3/movie/now_playing?";
        self.popular_url= @"https://api.themoviedb.org/3/movie/now_playing?api_key=6af6fb6deb5f2e4c6d36e514240eeebb&language=en-US&page=1";
        self.API_KEY =@"6af6fb6deb5f2e4c6d36e514240eeebb";
    }
    
    return self;
}

- (void) fetchMovieDetails:(NSString* )movieId completion:(void (^)(Movie*))callback {
    NSString *baseURL = @"https://api.themoviedb.org/3/movie/";
    NSString *concatString = [NSString stringWithFormat: @"%@%@?api_key=%@", baseURL,  movieId, _API_KEY];
    NSURL *url = [NSURL URLWithString: concatString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Request movie by ID error:", error);
            return;
        }
        
        @try {
            NSError *err;
            NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            
            Movie *movie = Movie.new;
            movie = [movie initByID:resultJSON];
            
           NSLog(@"ID DO MOVIE %@", movieId);
            
//            NSLog( @"%@", movie.genrerList.count);
            callback(movie);
            
        } @catch (NSException *exception) {
            NSLog(@"JSON Parse error: %@", exception);
            return;
        }
    }]resume];
}

- (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback {
    
    NSString *movies_GET_URL = [NSString alloc];
    
    if (moviesCategory == POPULAR) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/popular";
    } else if (moviesCategory == NOW_PLAYING) {
        movies_GET_URL = @"https://api.themoviedb.org/3/movie/now_playing";
    }
    
    NSString *urlString = [NSString stringWithFormat: @"%@?api_key=%@", movies_GET_URL, _API_KEY];
    NSURL *url = [NSURL URLWithString: urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Request error: %@", error);
            return;
        }
        
        @try {
            
            // JSON Dictionary object array
            NSError *err;
            NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            
            
            // Movie object array
            NSMutableArray *movies = [[NSMutableArray alloc] init];
            
            NSArray *moviesArray = resultJSON[@"results"];
            for (NSDictionary *movieDictionary in moviesArray) {
                Movie *movie = Movie.new;
                movie = [movie initWithDictionary:movieDictionary];
                
                [movies addObject:movie];
                
            }
            
            callback(movies);
        }
        
        @catch ( NSException *e ) {
            NSLog(@"JSON Parse error: %@", e);
            return;
        }
        
        
    }] resume];
    
}




@end
