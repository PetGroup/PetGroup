//
//  MoreCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 30, 30)];
        [self.headImageV setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.headImageV];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 30)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.titleLabel];
        
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
