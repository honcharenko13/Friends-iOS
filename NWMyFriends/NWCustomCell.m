//
//  NWCustomCellTableViewCell.m
//  NWMyFriends
//
//  Created by Alex on 10.03.16.
//  Copyright © 2016 Alex. All rights reserved.
//

#import "NWCustomCell.h"
#import "NWAddViewController.h"

@implementation NWCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addButtonAction:(id)sender {
    [self.delegate friendCellWasTapped:self];
}

- (IBAction)forgiveButtonAction:(id)sender {
    [self.delegate friendCellWasTapped:self];
}

@end
