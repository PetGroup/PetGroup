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
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 100, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
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
