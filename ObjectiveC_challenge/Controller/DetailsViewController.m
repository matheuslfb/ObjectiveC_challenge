//
//  DetailsViewController.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/16/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "DetailsViewController.h"
#import <UIKit/UIKit.h>
@interface DetailsViewController ()



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPosterImageView];
}

- (void)viewWillAppear:(BOOL)animated {    self.title = @"Movie Details";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
}
//
- (void) setupPosterImageView {
    self.posterImageView.layer.cornerRadius = 10;
    self.posterImageView.clipsToBounds = YES;
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
