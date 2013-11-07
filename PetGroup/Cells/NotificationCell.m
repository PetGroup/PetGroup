//
//  NotificationCell.m
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
