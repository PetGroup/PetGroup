//
//  PersonalDynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonalDynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"

@interface PersonalDynamicCell ()

@property (nonatomic,retain)UIView* backView;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@property (nonatomic,retain)NSArray* imageButtons;
@end

@implementation PersonalDynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
{
    CGFloat height = 10;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 200)];
        height += (msgSize.height+10);
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(210, 200)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 200)];
        height+=(msgSize.height+10);
    }
    if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
        height+=75;
    }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
        height+=145;
    }else if(dynamic.smallImage.count>6){
        height+=215;
    }
    return height>60?height:60;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_backView];
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [a addTarget:self action:@selector(loadBagImage:)  forControlEvents:UIControlEventTouchUpInside];
            [arr addObject:a];
        }
        self.imageButtons = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.textColor = [UIColor blackColor];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.adjustsFontSizeToFitWidth = YES;
        _timeL.minimumScaleFactor = 0.0;
        [self.contentView addSubview:_timeL];
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        [self.contentView addSubview:_transmitMsgL];
        
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
    for (UIView*a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }
    
    _timeL.frame = CGRectMake((self.contentView.frame.size.width-300)/2, 10, 80, 40);
    _timeL.text = self.dynamic.submitTime;
    CGFloat origin = 10;
    
    if (!self.dynamic.ifTransmitMsg) {
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 200)];
        _msgL.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 210, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 100;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            origin+=75;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = self.contentView.frame.size.width-220;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+70, 65, 65);
                originX+=70;
            }
            origin+=145;
        }else if(self.dynamic.smallImage.count>6){
            int originX = self.contentView.frame.size.width-220;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+70, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+140, 65, 65);
                originX+=70;
            }
            origin+=215;
        }
    }else{
        CGSize transmitMsgSize = [self.dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(210, 200)];
        self.transmitMsgL.frame =CGRectMake (self.contentView.frame.size.width-220, origin, 210, transmitMsgSize.height);
        _transmitMsgL.attributedText = self.dynamic.transmitMsg;
        origin = origin + transmitMsgSize.height +5;
        CGSize size = [self.dynamic.msg sizeConstrainedToSize:CGSizeMake(210, 200)];
        _msgL.frame = CGRectMake(self.contentView.frame.size.width-220, origin, 210, size.height);
        _msgL.attributedText = self.dynamic.msg;
        origin = origin + size.height + 10;
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = self.contentView.frame.size.width-220;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            origin+=75;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = self.contentView.frame.size.width-220;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+70, 65, 65);
                originX+=70;
            }
            origin+=145;
        }else if(self.dynamic.smallImage.count>6){
            int originX = self.contentView.frame.size.width-220;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+70, 65, 65);
                originX+=70;
            }
            originX = self.contentView.frame.size.width-220;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageButtons[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+140, 65, 65);
                originX+=70;
            }
            origin+=215;
        }
        
        self.backView.frame = CGRectMake(_msgL.frame.origin.x-10, _msgL.frame.origin.y-5, 220, origin-_msgL.frame.origin.y);
    }
}
-(void)loadBagImage:(EGOImageButton*)button
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (EGOImageButton*a in _imageButtons) {
        [array addObject:a.currentImage];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicCellPressImageButtonWithSmallImageArray:andImageIDArray:indext:)]) {
        [self.delegate dynamicCellPressImageButtonWithSmallImageArray:array andImageIDArray:self.dynamic.imgIDArray indext:button.tag-1000];
    }
}
#pragma mark - button action

@end
