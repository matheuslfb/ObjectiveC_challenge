//
//  ViewController.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/16/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

// url example: https://api.themoviedb.org/3/movie/550?api_key=6af6fb6deb5f2e4c6d36e514240eeebb


NSString *base_url ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.API_KEY =  @"6af6fb6deb5f2e4c6d36e514240eeebb";
    self.popularURL = @"https://api.themoviedb.org/3/movie/popular?";
    base_url = [NSString stringWithFormat: @"%@%@", _popularURL, _API_KEY];
    
    
    self.view.backgroundColor = UIColor.blackColor;
    [self fetchMovies];
}

- (void) fetchMovies {
    NSLog(@"Fetching movies");
    NSLog(base_url);
    NSString *url = @"";
}


@end
