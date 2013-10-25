//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"

@interface DynamicCell ()

{
    UIButton* nameB;
    EGOImageButton* headB;
    UIButton* zanB;
    UIButton* replyB;
    UIButton* zhuanfaB;
}
@property (nonatomic,retain)UIImageView * zanImageV;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@property (nonatomic,retain)NSArray* imageButtons;
@property (nonatomic,retain)UIImageView* bottomIV;
@end
@implementation DynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic
{
    return 100;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [a addTarget:self action:@selector(loadBagImage)  forControlEvents:UIControlEventTouchUpInside];
            [arr addObject:a];
        }
        self.imageButtons = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_msgL];
        
        self.bottomIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing"]];
        [self.contentView addSubview:_bottomIV];
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        zanB.frame = CGRectMake(5, 5, 100, 23.5);
        [zanB addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
        [zanB setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [zanB setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateHighlighted];
        [_bottomIV addSubview:zanB];
        replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        replyB.frame = CGRectMake(110, 5, 100, 23.5);
        [replyB addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [replyB setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [replyB setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateHighlighted];
        [_bottomIV addSubview:replyB];
        zhuanfaB = [UIButton buttonWithType:UIButtonTypeCustom];
        zhuanfaB.frame = CGRectMake(215, 5, 100, 23.5);
        [zhuanfaB addTarget:self action:@selector(zhuanfaAction) forControlEvents:UIControlEventTouchUpInside];
        [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [zhuanfaB setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateHighlighted];
        [_bottomIV addSubview:zhuanfaB];
        
        self.zanImageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 14, 15)];
        [zanB addSubview:_zanImageV];
        
        UIImageView* replyIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 12.5)];
        replyIV.image = [UIImage imageNamed:@"pinglun"];
        [replyB addSubview:replyIV];
        
        UIImageView * zhuanfaIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 14, 16.5)];
        zhuanfaIV.image = [UIImage imageNamed:@"zhuanfa"];
        [zhuanfaB addSubview:zhuanfaIV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView*a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }
    headB.frame = CGRectMake(10, 10, 40, 40);
    nameB.frame = CGRectMake(60, 10, 50, 20);
    _timeL.frame = CGRectMake(60, 30, 50, 20);
    _msgL.frame = CGRectMake(10, 60, 300, 80);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - button action
-(void)PersonDetail
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressNameButtonOrHeadButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressNameButtonOrHeadButtonAtIndexPath:self.indexPath];
    }
}
-(void)zanAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressZanButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressZanButtonAtIndexPath:self.indexPath];
    }
}
-(void)replyAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressReplyButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressReplyButtonAtIndexPath:self.indexPath];
    }
}
-(void)zhuanfaAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressZhuangFaButtonAtIndexPath:)]) {
        [self.delegate dynamicCellPressZhuangFaButtonAtIndexPath:self.indexPath];
    }
}
-(void)loadBagImage
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressImageButtonWithSmallImageArray:andImageIDArray:)]) {
        [self.delegate dynamicCellPressImageButtonWithSmallImageArray:nil andImageIDArray:nil];
    }
}
@end
