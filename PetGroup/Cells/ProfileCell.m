//
//  ProfileCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ProfileCell.h"

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 20)];
        [self.describeLabel setBackgroundColor:[UIColor clearColor]];
        [self.describeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.describeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
