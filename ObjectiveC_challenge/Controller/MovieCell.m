//
//  MovieCell.m
//  ObjectiveC_challenge
//
//  Created by Matheus Lima Ferreira on 3/18/20.
//  Copyright © 2020 Matheus Lima Ferreira. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.poster.layer.cornerRadius = 10;
    self.poster.clipsToBounds = YES;
    
    // Configure the view for the selected state
}

@end
