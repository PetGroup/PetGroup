//
//  MyProfileACell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileACell.h"

@implementation MyProfileACell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.titleLabel];
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(287, 13.75, 8.5, 12.5)];
        [_arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
        [self.contentView addSubview:_arrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
