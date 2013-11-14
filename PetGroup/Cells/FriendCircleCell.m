//
//  FriendCircleCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleCell.h"
#import "EGOImageView.h"
#import "OHAttributedLabel.h"
@interface FriendCircleCell ()
//@property (nonatomic,retain)EGOImageView* imageV;
//@property (nonatomic,retain)OHAttributedLabel* titleL;
@property (nonatomic,retain)UIView* colorV;
@end
@implementation FriendCircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.contentView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
//        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//        _imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
//        [self.contentView addSubview:_imageV];
//        
//        self.titleL = [[OHAttributedLabel alloc]initWithFrame:CGRectMake(70, 10, 240, 50)];
//        _titleL.backgroundColor = [UIColor clearColor];
//        _titleL.font = [UIFont systemFontOfSize:12];
//        _titleL.numberOfLines = 0;
//        [self.contentView addSubview:_titleL];
        UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 152.5, 80)];
        bg.image = [UIImage imageNamed:@"quanzi_bg"];
        [self.contentView addSubview:bg];
        self.colorV = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.colorV.backgroundColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.8 alpha:1];
        self.colorV.layer.cornerRadius = 5;
        [self.contentView addSubview:_colorV];
        
        UILabel* bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        bigLabel.backgroundColor = [UIColor clearColor];
        bigLabel.textAlignment = NSTextAlignmentCenter;
        [bigLabel setNumberOfLines:0];
        bigLabel.font = [UIFont boldSystemFontOfSize:25];
        [bigLabel setTextColor:[UIColor whiteColor]];
        bigLabel.text = @"好友动态";
        [self.contentView addSubview:bigLabel];
        
        UILabel*quanziNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 8, 80, 13)];
        quanziNameLabel.backgroundColor = [UIColor clearColor];
        quanziNameLabel.textColor = [UIColor orangeColor];
        quanziNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:quanziNameLabel];
        quanziNameLabel.text = @"好友动态";
        
        UILabel*todayTopicL = [[UILabel alloc]initWithFrame:CGRectMake(80, 26, 80, 13)];
        todayTopicL.backgroundColor = [UIColor clearColor];
        todayTopicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:todayTopicL];
        UILabel*topicL = [[UILabel alloc]initWithFrame:CGRectMake(80, 42, 80, 13)];
        topicL.backgroundColor = [UIColor clearColor];
        topicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:topicL];
        UILabel*replyL = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 13)];
        replyL.backgroundColor = [UIColor clearColor];
        replyL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:replyL];
        todayTopicL.text =@"今日话题";
        topicL.text = @"话题";
        replyL.text = @"回复";
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    if (_dynamic.smallImage.count>0) {
//        _imageV.hidden = NO;
//        _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[0]]];
//        CGSize size =  [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(230, 40)];
//        _titleL.frame = CGRectMake(70, 10, 230, size.height);
//    }else{
//        _imageV.hidden = YES;
//        _imageV.imageURL = [NSURL URLWithString:@""];
//        CGSize size =  [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 40)];
//        _titleL.frame = CGRectMake(20, 10, 280, size.height);
//    }
//    
//    _titleL.attributedText = _dynamic.msg;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
