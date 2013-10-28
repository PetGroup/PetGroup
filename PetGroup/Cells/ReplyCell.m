//
//  ReplyCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReplyCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"
@interface ReplyCell ()<UIAlertViewDelegate,UIActionSheetDelegate,OHAttributedLabelDelegate>
{
    UIButton* nameB;
    EGOImageButton* headB;
}
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@end
@implementation ReplyCell
+(CGFloat)heightForRowWithDynamic:(Reply*)reply;
{
    CGFloat height = 60;
    CGSize msgSize = [reply.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
    return height += msgSize.height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
        
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
    headB.frame = CGRectMake(10, 10, 40, 40);
    headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.reply.userHeadImage]];
    CGSize nameSize = [self.reply.nickName sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, 20);
    [nameB setTitle:self.reply.nickName forState:UIControlStateNormal];
    
    CGSize timeSize = [self.reply.submitTime sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 12) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.frame = CGRectMake(60, 30, timeSize.width, timeSize.height);
    _timeL.text = self.reply.submitTime;
    
    CGSize size = [self.reply.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
    _msgL.frame = CGRectMake(10, 55, 300, size.height);
    _msgL.attributedText = self.reply.msg;
}
-(void)PersonDetail
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressNameButtonOrHeadButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressNameButtonOrHeadButtonAtIndexPath:self.indexPath];
    }
}
@end
