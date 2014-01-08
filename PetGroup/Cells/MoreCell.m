//
//  MoreCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MoreCell.h"
@interface MoreCell ()
@property (nonatomic,retain)UIView*lineV;
@end
@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        [self.headImageV setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.headImageV];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 8.5, 28, 22)];
        float diffH = [Common diffHeight:nil];
        [self.notiBgV setImage:diffH==0.0f?[UIImage imageNamed:@"redCB.png"]:[UIImage imageNamed:@"redCB2.png"]];
        self.notiBgV.tag=999;
        [self.contentView addSubview:self.notiBgV];
        self.unreadCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(-1, -1, 30, 22)];
        [self.unreadCountLabel setBackgroundColor:[UIColor clearColor]];
        [self.unreadCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.unreadCountLabel setAdjustsFontSizeToFitWidth:YES];
        [self.unreadCountLabel setTextColor:[UIColor whiteColor]];
        [self.notiBgV addSubview:self.unreadCountLabel];
        self.notiBgV.hidden = YES;
        
        self.lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_lineV];

        
//        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-30, 12.7, 8.5, 12.5)];
//        [self.arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
//        [self.contentView addSubview:self.arrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _lineV.frame = CGRectMake(0, self.contentView.frame.size.height-1, 320, 1);
}
@end
