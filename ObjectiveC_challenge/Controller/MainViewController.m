//
//  MainViewController.m
//  ObjectiveC_challenge
//
//  Created by Ronald Maciel on 17/03/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>
#import "Network.h"
#import "Movie.h"

@interface MainViewController (){
    Network *network;
}
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovie;
@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@end



@implementation MainViewController {
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    network = [[Network alloc] init];
    
    // Do any additional setup after loading the view.
    tableData = [NSArray arrayWithObjects:@"Bateta", @"Luisa", @"Luna",nil];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        _nowPlayingMovie = [network fetchPopularMovies];
    });
    
}


- (IBAction)showDetails:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    DetailsViewController * detail = [storyboard instantiateInitialViewController];
    
    
    [self showViewController:detail sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Popular";
    } else if (section == 1) {
        return @"Now Playing";
    }
    return @"kkk";
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text = tableData[indexPath.row];
    
    return cell;
}

@end
