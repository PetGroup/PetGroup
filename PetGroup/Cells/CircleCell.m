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
@property (nonatomic,retain)UILabel* bigLabel;
@property (nonatomic,retain)UILabel* quanziNameLabel;
@property (nonatomic,retain)UILabel* todayTopicL;
@property (nonatomic,retain)UILabel* topicL;
@property (nonatomic,retain)UILabel* replyL;
//@property (nonatomic,retain)UILabel* nameL;
//@property (nonatomic,retain)UILabel* joinI;

@end
@implementation CircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 152.5, 80)];
        bg.image = [UIImage imageNamed:@"quanzi_bg"];
        [self.contentView addSubview:bg];
        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.imageV.layer.cornerRadius = 5;
//        UIColor * color1 = [UIColor colorWithRed:0.6 green:0.7 blue:0.2 alpha:1];
//        UIColor * color2 = [UIColor colorWithRed:0.2 green:0.6 blue:0.4 alpha:1];
//        UIColor * color3 = [UIColor colorWithRed:0.1 green:0.3 blue:0.8 alpha:1];
//        UIColor * color4 = [UIColor colorWithRed:0.7 green:0.3 blue:0.6 alpha:1];
//        UIColor * color5 = [UIColor colorWithRed:0.6 green:0.5 blue:0.2 alpha:1];
//        NSArray * array = [NSArray arrayWithObjects:color1,color2,color4,color5,color3, nil];
//        int g = arc4random()%4;
//        self.imageV.backgroundColor = array[g];
//        _imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_imageV];
        self.bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.bigLabel.backgroundColor = [UIColor clearColor];
        self.bigLabel.textAlignment = NSTextAlignmentCenter;
        //        [self.replyLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.bigLabel setNumberOfLines:0];
        self.bigLabel.font = [UIFont boldSystemFontOfSize:25];
        [self.bigLabel setTextColor:[UIColor whiteColor]];
//        self.bigLabel.text = @"苏格兰折耳猫";
        [self.contentView addSubview:self.bigLabel];
        
        self.quanziNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 8, 80, 13)];
        self.quanziNameLabel.backgroundColor = [UIColor clearColor];
        self.quanziNameLabel.textColor = [UIColor orangeColor];
        self.quanziNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.quanziNameLabel];
//        self.quanziNameLabel.text = @"哈士奇犬";
        
        self.todayTopicL = [[UILabel alloc]initWithFrame:CGRectMake(80, 26, 80, 13)];
        _todayTopicL.backgroundColor = [UIColor clearColor];
//        _todayTopicL.textColor = [UIColor orangeColor];
        _todayTopicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_todayTopicL];
        self.topicL = [[UILabel alloc]initWithFrame:CGRectMake(80, 42, 80, 13)];
        _topicL.backgroundColor = [UIColor clearColor];
        _topicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_topicL];
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 13)];
        _replyL.backgroundColor = [UIColor clearColor];
        _replyL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_replyL];
//        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 152.5, 20)];
//        _nameL.backgroundColor = [UIColor clearColor];
//        _nameL.font = [UIFont boldSystemFontOfSize:14];
////        _nameL.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_nameL];
        
//        self.joinI = [[UILabel alloc]initWithFrame:CGRectMake(116, 3, 35, 23)];
//        _joinI.text = @"已关注";
//        _joinI.textColor = [UIColor grayColor];
//        _joinI.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:_joinI];
//        _joinI.font = [UIFont systemFontOfSize:11];
//        _joinI.hidden = YES;
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
   // _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.entity.imageID]];
    _todayTopicL.text =[NSString stringWithFormat:@"今日话题:%@",self.entity.todayTotal];
    _topicL.text = [NSString stringWithFormat:@"话题:%@",self.entity.totalCount];
    _replyL.text = [NSString stringWithFormat:@"回复:%@",self.entity.totalReply];
//    _nameL.text = [NSString stringWithFormat:@"%@",self.entity.name];
    self.bigLabel.text = [NSString stringWithFormat:@"%@",self.entity.name];
    self.quanziNameLabel.text = [NSString stringWithFormat:@"%@",self.entity.name];
    self.imageV.backgroundColor = self.entity.theColor;
    if (self.entity.name.length<=4) {
        self.bigLabel.font = [UIFont boldSystemFontOfSize:23];
    }
    else
        self.bigLabel.font = [UIFont boldSystemFontOfSize:17];
//    if (!self.entity.atte) {
//        _joinI.hidden = YES;
//    }else{
//        _joinI.hidden = NO;
//    }
}
@end
