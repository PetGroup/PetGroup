//
//  CircleCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleCell.h"
#import "EGOImageView.h"
@interface CircleCell ()

@property (nonatomic,retain)EGOImageView* imageV;
@property (nonatomic,retain)UILabel* todayTopicL;
@property (nonatomic,retain)UILabel* topicL;
@property (nonatomic,retain)UILabel* replyL;
@property (nonatomic,retain)UILabel* nameL;
@property (nonatomic,retain)UILabel* joinI;

@end
@implementation CircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 152.5, 100)];
        bg.image = [UIImage imageNamed:@"quanzi_bg"];
        [self.contentView addSubview:bg];
        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 40, 50, 50)];
        _imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_imageV];
        self.todayTopicL = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 80, 13)];
        _todayTopicL.backgroundColor = [UIColor clearColor];
//        _todayTopicL.textColor = [UIColor orangeColor];
        _todayTopicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_todayTopicL];
        self.topicL = [[UILabel alloc]initWithFrame:CGRectMake(70, 58, 80, 13)];
        _topicL.backgroundColor = [UIColor clearColor];
        _topicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_topicL];
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(70, 76, 80, 13)];
        _replyL.backgroundColor = [UIColor clearColor];
        _replyL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_replyL];
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 152.5, 20)];
        _nameL.backgroundColor = [UIColor clearColor];
        _nameL.font = [UIFont boldSystemFontOfSize:14];
//        _nameL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameL];
        
        self.joinI = [[UILabel alloc]initWithFrame:CGRectMake(116, 3, 35, 23)];
        _joinI.text = @"已关注";
        _joinI.textColor = [UIColor grayColor];
        _joinI.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_joinI];
        _joinI.font = [UIFont systemFontOfSize:11];
        _joinI.hidden = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.entity.imageID]];
    _todayTopicL.text =[NSString stringWithFormat:@"今日话题:%@",self.entity.todayTotal];
    _topicL.text = [NSString stringWithFormat:@"话题:%@",self.entity.totalCount];
    _replyL.text = [NSString stringWithFormat:@"回复:%@",self.entity.totalReply];
    _nameL.text = [NSString stringWithFormat:@"%@",self.entity.name];
    if (!self.entity.atte) {
        _joinI.hidden = YES;
    }else{
        _joinI.hidden = NO;
    }
}
@end
