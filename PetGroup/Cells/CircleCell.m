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
        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 70, 70)];
        self.imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_imageV];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 180, 25)];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.textColor = [UIColor blackColor];
        self.nameL.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.nameL];
        
        self.todayTopicL = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 80, 20)];
        _todayTopicL.backgroundColor = [UIColor clearColor];
        _todayTopicL.textColor = [UIColor grayColor];
        _todayTopicL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_todayTopicL];
        self.topicL = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 80, 20)];
        _topicL.backgroundColor = [UIColor clearColor];
        _topicL.font = [UIFont systemFontOfSize:14];
        _topicL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_topicL];
        self.replyL = [[UILabel alloc]initWithFrame:CGRectMake(160, 50, 80, 20)];
        _replyL.backgroundColor = [UIColor clearColor];
        _replyL.font = [UIFont systemFontOfSize:14];
        _replyL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_replyL];
        
        self.joinB = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinB.frame = CGRectMake(280, 60, 40, 20);
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
        [_joinB setTitle:@"加入" forState:UIControlStateNormal];
      }else{
        [_joinB setTitle:@"退出" forState:UIControlStateNormal];
      }
}
-(void)joinAction{
    if (self.delegate&& [_delegate respondsToSelector:@selector(circleCellPressJoinBWithIndexPath:)]) {
        [self.delegate circleCellPressJoinBWithIndexPath:self.indexPath];
    }
}
@end
