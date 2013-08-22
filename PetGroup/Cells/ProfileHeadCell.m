//
//  ProfileHeadCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ProfileHeadCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation ProfileHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.headImageV setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.headImageV];
        self.headImageV.layer.cornerRadius = 8;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 80, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 145, 20)];
        [self.describeLabel setBackgroundColor:[UIColor clearColor]];
        [self.describeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.describeLabel];
        
        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(287, 22.7, 8.5, 12.5)];
        [arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
        [self.contentView addSubview:arrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
