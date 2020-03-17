//
//  Movie.h
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/17/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"
NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *poster_path;
@property (strong, nonatomic) NSMutableArray *all_genres;
@property (strong, nonatomic) NSMutableArray<Genre *> *genre_ids;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *vote_average;
@property (strong, nonatomic) NSString *overview;

@end

NS_ASSUME_NONNULL_END
