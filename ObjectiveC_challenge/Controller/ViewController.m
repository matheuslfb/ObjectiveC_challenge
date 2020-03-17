//
//  ViewController.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/16/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "ViewController.h"
#import "DetailsViewController.h"

@interface ViewController ()



@end

@implementation ViewController

// url example: https://api.themoviedb.org/3/movie/550?api_key=6af6fb6deb5f2e4c6d36e514240eeebb


NSString *base_url ;

- (IBAction)showDetails:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MovieDetails" bundle:nil];
    DetailsViewController * detail = [storyboard instantiateInitialViewController];
    detail.title = @"Movie Details";
    
    
    [self showViewController:detail sender:self];
//    [self presentViewController:detail animated:YES completion:nil];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.API_KEY =  @"6af6fb6deb5f2e4c6d36e514240eeebb";
    self.popularURL = @"https://api.themoviedb.org/3/movie/popular?api_key=";
    base_url = [NSString stringWithFormat: @"%@%@", _popularURL, _API_KEY, @"&language=en-US&page=1"];
    
//    
//    self.view.backgroundColor = UIColor.blackColor;
//    [self fetchMovies];
}

- (void) fetchMovies {
    NSLog(@"Fetching movies");
    NSLog(base_url);
    
    NSURL *url = [NSURL URLWithString: base_url];
    
  [  [NSURLSession.sharedSession dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      NSLog(@"Finished fetching movies");
      NSString *teste = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      
      NSLog(teste);
  }] resume];
    
}


@end
