//
//  Movie.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/17/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "Movie.h"

@implementation Movie
-(id) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [self init];
    
    if (self) {
        
        NSString *movieID = dictionary[@"id"];
        NSString *title = dictionary[@"title"];
        NSString *overview = dictionary[@"overview"];
        NSNumber *rating = dictionary[@"vote_average"];
        NSString *imageUrl = dictionary[@"poster_path"];
        
        self.movieID = movieID;
        self.title = title;
        self.overview = overview;
        self.rating = rating;
        self.imageUrl = imageUrl;
        
    }
    
    return self;
}

-(id) initByID:(NSDictionary*) dictionary{
    
    NSString *movieID = dictionary[@"id"];
    NSString *title = dictionary[@"title"];
    NSString *overview = dictionary[@"overview"];
    NSNumber *rating = dictionary[@"vote_average"];
    NSString *imageUrl = dictionary[@"poster_path"];
    
    self.movieID = movieID;
    self.title = title;
    self.overview = overview;
    self.rating = rating;
    self.imageUrl = imageUrl;
    
    self.genreList = NSMutableArray.new;
    
    NSMutableArray* genres = dictionary[@"genres"];
    for (NSDictionary *genreDictionary in genres) {
        NSString* genre =  genreDictionary[@"name"];
        [self.genreList addObject: genre];
        
    }
    return self;
}

@end
