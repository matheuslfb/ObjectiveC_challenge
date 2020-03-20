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

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *movieID;
@property (nonatomic) NSMutableArray<NSString*> *genrerList;

-(id) initWithDictionary:(NSDictionary *) dictionary;
-(id) initByID:(NSDictionary*) dictionary;
@end

NS_ASSUME_NONNULL_END
