//
//  MainViewController.m
//  ObjectiveC_challenge
//
//  Created by Ronald Maciel on 17/03/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated   {
    self.navigationItem.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;

}

- (IBAction)showDetails:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    DetailsViewController * detail = [storyboard instantiateInitialViewController];


    [self showViewController:detail sender:self];
}



@end
