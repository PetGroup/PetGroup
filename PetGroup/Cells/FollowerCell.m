//
//  FollowerCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FollowerCell.h"
#import "EGOImageView.h"

@interface FollowerCell ()
{
    UIButton *replyB;
    UIButton *reportB;
}
@property(nonatomic,retain)EGOImageView* headPhote;
@property(nonatomic,retain)UILabel* nameL;
@property(nonatomic,retain)UILabel* timeL;
@property(nonatomic,retain)UILabel* contentL;
@property(nonatomic,retain)UILabel* locationL;
@end
@implementation FollowerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headPhote = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _headPhote.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_headPhote];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 50, 12)];
        _nameL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 12)];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        self.locationL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 140, 20)];
        _locationL.numberOfLines = 0;
        _locationL.font = [UIFont systemFontOfSize:14];
        _locationL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_locationL];
        
        self.contentL = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 50, 12)];
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentL];
        
        replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyB setTitle:@"回复" forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_normal"] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"huifu_click"] forState:UIControlStateHighlighted];
        [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:replyB];
        reportB = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportB setTitle:@"举报" forState:UIControlStateNormal];
        [reportB addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:reportB];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)replyAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(followerCellPressReplyButtonAtIndexPath:)]) {
        [self.delegate followerCellPressReplyButtonAtIndexPath:self.indexPath];
    }
}
-(void)reportAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(followerCellPressReportButtonAtIndexPath:)]) {
        [self.delegate followerCellPressReportButtonAtIndexPath:self.indexPath];
    }
}
@end
