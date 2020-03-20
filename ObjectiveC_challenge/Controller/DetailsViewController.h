//
//  DetailsViewController.h
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/16/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN


@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleMovie;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;

@property (weak, nonatomic) NSString *imageURL;

@property(nonatomic) Movie* movie;


-(void) configureWithMovie:(Movie *) movieDetail;

@end

NS_ASSUME_NONNULL_END
