//
//  MessageCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(38, 0, 28, 22)];
        [self.notiBgV setImage:[UIImage imageNamed:@"redCB.png"]];
        self.notiBgV.tag=999;
        [self.contentView addSubview:self.notiBgV];
//        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, 30, 22)];
//        [numberLabel setBackgroundColor:[UIColor clearColor]];
//        [numberLabel setTextColor:[UIColor whiteColor]];
//        [numberLabel setFont:[UIFont systemFontOfSize:14]];
//        [numberLabel setTextAlignment:NSTextAlignmentCenter];
//        [notiBgV addSubview:numberLabel];
        self.unreadCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, -1, 30, 22)];
        [self.unreadCountLabel setBackgroundColor:[UIColor clearColor]];
        [self.unreadCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.unreadCountLabel setTextColor:[UIColor whiteColor]];
        [self.notiBgV addSubview:self.unreadCountLabel];
        [self.notiBgV setHidden:YES];
        self.unreadCountLabel.hidden = YES;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:self.nameLabel];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 240, 20)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.contentLabel];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 100, 20)];
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
