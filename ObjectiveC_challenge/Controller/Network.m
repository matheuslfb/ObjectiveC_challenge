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

- (NSMutableArray*) fetchPopularMovies {
    NSLog(@"Fetching movies");
    NSLog(_popular_url);
    
    
   NSLog(@"Fetching movies...");
    
    NSURL *url = [NSURL URLWithString:_popular_url];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching Movies.");
        
        /// Uncomment these lines to se
        /// the returned movies list printed
        /// on console
        /*
        NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", jsonResponse);
        */
        
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    
        if (err) {
            NSLog(@"Failed to serialize data into JSON: %@", err);
            return;
        }
        
        self.popularMovies = NSMutableArray.new;
        
        NSArray *moviesArray = resultJSON[@"results"];
        for (NSDictionary *movieDictionary in moviesArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [self.popularMovies addObject:movie];
            
        }
        
    }] resume];
    
    return _popularMovies;
}

@end
