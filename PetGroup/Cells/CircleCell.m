//
//  CircleCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-28.
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

@end
@implementation CircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.imageV.placeholderImage = [UIImage imageNamed:@"circleplaceholder"];
        [self.contentView addSubview:_imageV];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 180, 20)];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.textColor = [UIColor blackColor];
        self.nameL.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.nameL];
        
        self.todayTopicL = [[UILabel alloc]initWithFrame:CGRectMake(200, 40, 80, 20)];
        _todayTopicL.backgroundColor = [UIColor clearColor];
        _todayTopicL.textColor = [UIColor grayColor];
        _todayTopicL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_todayTopicL];
        self.topicL = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 80, 20)];
        _topicL.backgroundColor = [UIColor clearColor];
        _topicL.font = [UIFont systemFontOfSize:12];
        _topicL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_topicL];
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 80, 20)];
        _replyL.backgroundColor = [UIColor clearColor];
        _replyL.font = [UIFont systemFontOfSize:12];
        _replyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_replyL];
        
        self.joinB = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinB.frame = CGRectMake(260, 0, 50, 50);
        [_joinB addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [_joinB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_joinB];
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
    _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.circle.imageID]];
    _nameL.text = self.circle.name;
    _todayTopicL.text =[NSString stringWithFormat:@"今日:%@",self.circle.todayTotal];
    _topicL.text = [NSString stringWithFormat:@"话题:%@",self.circle.totalCount];
    _replyL.text = [NSString stringWithFormat:@"回复:%@",self.circle.totalReply];
    if (!self.circle.atte) {
        [_joinB setBackgroundImage:[UIImage imageNamed:@"joinB"] forState:UIControlStateNormal];
      }else{
        [_joinB setBackgroundImage:[UIImage imageNamed:@"quitB"] forState:UIControlStateNormal];
      }
}
-(void)joinAction{
    if (self.delegate&& [_delegate respondsToSelector:@selector(circleCellPressJoinBWithIndexPath:)]) {
        [self.delegate circleCellPressJoinBWithIndexPath:self.indexPath];
    }
}
@end
