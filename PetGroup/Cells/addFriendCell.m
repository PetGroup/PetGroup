//
//  addFriendCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-2.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "addFriendCell.h"

@implementation addFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
//        self.headImageV.layer.cornerRadius = 5;
//        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        UIImageView * bgbgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [bgbgV setImage:[UIImage imageNamed:@"headMask.png"]];
        [self.contentView addSubview:bgbgV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(38, 0, 28, 22)];
        float diffH = [Common diffHeight:nil];
        [self.notiBgV setImage:diffH==0.0f?[UIImage imageNamed:@"redCB.png"]:[UIImage imageNamed:@"redCB2.png"]];
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

        
        self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 100, 20)];
        [self.msgLabel setTextAlignment:NSTextAlignmentLeft];
        [self.msgLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.msgLabel];
        [self.msgLabel setBackgroundColor:[UIColor clearColor]];
        
        self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.agreeBtn setFrame:CGRectMake(170, 15, 65, 30)];
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"selected-big.png"] forState:UIControlStateNormal];
        [self.agreeBtn setTitle:@"通过" forState:UIControlStateNormal];
        [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.agreeBtn];
        
        self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rejectBtn setFrame:CGRectMake(245, 15, 65, 30)];
        [self.rejectBtn setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
        [self.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.rejectBtn];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
