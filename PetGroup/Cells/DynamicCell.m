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
@property (nonatomic,retain)UIView* backView;
@property (nonatomic,retain)UIImageView * zanImageV;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@property (nonatomic,retain)NSArray* imageButtons;
@property (nonatomic,retain)UIImageView* bottomIV;
@end
@implementation DynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic
{
    CGFloat height = 60;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height += msgSize.height;
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height+=(msgSize.height+5);
    }
    if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
        height+=85;
    }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
        height+=165;
    }else if(dynamic.smallImage.count>6){
        height+=245;
    }

    return height+=33.5;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_backView];
        
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
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        [self.contentView addSubview:_transmitMsgL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
        
        self.bottomIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"beijing"]];
        _bottomIV.userInteractionEnabled = YES;
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
    headB.imageURL = [NSURL URLWithString:self.dynamic.userHeadImage];
    CGSize nameSize = [self.dynamic.nickName sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, 20);
    [nameB setTitle:self.dynamic.nickName forState:UIControlStateNormal];
    
    CGSize timeSize = [self.dynamic.submitTime sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 12) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.frame = CGRectMake(60, 30, timeSize.width, timeSize.height);
    _timeL.text = self.dynamic.submitTime;
    
    CGFloat origin = 55;
    
    if (!self.dynamic.ifTransmitMsg) {
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        _msgL.frame = CGRectMake(10, origin, 300, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 5;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 60;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+160, 75, 75);
                originX+=80;
            }
            origin+=245;
        }
    }else{
        CGSize transmitMsgSize = [self.dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(300, 200)];
        self.transmitMsgL.frame =CGRectMake (10, 55, 300, transmitMsgSize.height);
         _transmitMsgL.attributedText = self.dynamic.transmitMsg;
        origin = origin + transmitMsgSize.height + 5;
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        _msgL.frame = CGRectMake(10, origin, 300, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 5;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 60;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            origin+=85;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            origin+=165;
        }else if(self.dynamic.smallImage.count>6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 75, 75);
                originX+=80;
            }
            originX = 60;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+160, 75, 75);
                originX+=80;
            }
            origin+=245;
        }
        self.backView.frame = CGRectMake(_msgL.frame.origin.x, _msgL.frame.origin.y, 300, origin-_msgL.frame.origin.y);
    }
    
    
    _bottomIV.frame = CGRectMake(0, origin, 320, 33.5);
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
