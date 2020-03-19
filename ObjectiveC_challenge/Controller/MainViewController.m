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
#import "MovieCell.h"

@interface MainViewController (){
    Network *network;
}
@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovie;
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
        self.popularMovies = [self->network fetchPopularMovies];
        //        self.nowPlayingMovie = [self->network fetchNowPlaying];
        
        [self.mainTableView reloadData];
    });
}

- (IBAction)showDetails:(id)sender {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:nil];
    //        DetailsViewController * detail = [storyboard instantiateInitialViewController];
    //
    //
    //        [self showViewController:detail sender:self];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_popularMovies = [network fetchPopularMovies];
        self->_nowPlayingMovie = [network fetchPopularMovies];
        [self.mainTableView reloadData];
        //
    });
    
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
    if (section == 0) {
        return [self.popularMovies count];
    } else if (section == 1) {
        return [self.nowPlayingMovie count];
    }
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CellID";
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
//
    } else if (indexPath.section == 1) {
    
        Movie *movie = self.nowPlayingMovie[indexPath.row];
        
        if (movie != nil) {
            cell.title.text = movie.title;
            cell.overview.text = movie.overview;
            cell.rating.text = movie.rating.stringValue;
            
            // image
            //        NSLog(movie.imageUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                // https://image.tmdb.org/t/p/w500/
                NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
                NSString *imagePath = [NSString stringWithFormat: @"%@%@", baseURL, movie.imageUrl];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imagePath]];
                cell.poster.image = [UIImage imageWithData: imageData];
            });
        }
    }
    
    return cell;
}

@end
