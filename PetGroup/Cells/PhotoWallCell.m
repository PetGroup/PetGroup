//
//  PhotoWallCell.m
//  PetGroup
//
//  Created by Tolecen on 13-9-2.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PhotoWallCell.h"

@implementation PhotoWallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.photoWall];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
