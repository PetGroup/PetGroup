//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"
#import "Common.h"
#import "EGOImageButton.h"
#import "PersonDetailViewController.h"
#import "CustomTabBar.h"
#import "FullTextViewController.h"

@interface DynamicCell ()

{
    UIButton* nameB;
    EGOImageButton* headB;
    UIButton * quanwenB;
    UIButton * pushB;
    UIButton* moveB;
    CGSize msgSize;
    CGSize msgMinSize;
    float origin;
}
@property (nonatomic,retain)NSArray* imageViews;
@property (nonatomic,retain)UILabel* msgL;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)UILabel* transmitMsgL;
@property (nonatomic,retain)UILabel* beijingL;

@end
@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.beijingL = [[UILabel alloc]init];
        _beijingL.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_beijingL];
        
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
        self.transmitMsgL = [[UILabel alloc]init];
        [self.contentView addSubview:_transmitMsgL];
        _transmitMsgL.font = [UIFont systemFontOfSize:12];
        
        self.msgL = [[UILabel alloc]init];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
        _msgL.font = [UIFont systemFontOfSize:12];
        
        quanwenB = [UIButton buttonWithType:UIButtonTypeCustom];
        [quanwenB setTitle:@"展开" forState:UIControlStateNormal];
        [quanwenB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        quanwenB.titleLabel.font = [UIFont systemFontOfSize:12];
        [quanwenB addTarget:self action:@selector(quanwen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:quanwenB];
        
        pushB = [UIButton buttonWithType:UIButtonTypeCustom];
        [pushB addTarget:self action:@selector(pushQuanwen) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:pushB];
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [arr addObject:a];
        }
        self.imageViews = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        moveB = [UIButton buttonWithType:UIButtonTypeCustom];
        [moveB setBackgroundImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
        [self.contentView addSubview:moveB];
        [moveB addTarget:self action:@selector(showButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView* a in self.contentView.subviews) {
        a.frame = CGRectZero;
    }

    headB.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.headID]];
    headB.frame = CGRectMake(10, 10, 40, 40);
    [nameB setTitle:self.dynamic.name forState:UIControlStateNormal];
    CGSize nameSize = [self.dynamic.name sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(240, 20) lineBreakMode:NSLineBreakByWordWrapping];
    nameB.frame = CGRectMake(60, 10, nameSize.width, nameSize.height);
    
    origin = 40;
    
    if (self.dynamic.ifTransmitMsg != 0) {
        CGSize size = [self.dynamic.transmitMsg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:NSLineBreakByWordWrapping];
        self.transmitMsgL.text = self.dynamic.transmitMsg;
        self.transmitMsgL.frame = CGRectMake(60, origin, size.width, size.height);
        origin += (size.height+10);
        
        msgSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
        if (msgSize.height<75) {
            self.msgL.frame =CGRectMake(60, origin, msgSize.width, msgSize.height);
            origin+=(msgSize.height+10);
        }else{
            self.msgL.frame =CGRectMake(60, origin, 240, 15);
            origin+=25;
            pushB.frame = _msgL.frame;
        }
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            origin+=80;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            origin=160;
        }else if(self.dynamic.smallImage.count>6){
            origin+=240;
        }
        self.beijingL.frame = CGRectMake(self.msgL.frame.origin.x, self.msgL.frame.origin.y, 240, origin-self.msgL.frame.origin.x);
    }else{
        _msgL.backgroundColor= [UIColor whiteColor];
        msgMinSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240, 75) lineBreakMode:NSLineBreakByWordWrapping];
        msgSize = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240, 200) lineBreakMode:NSLineBreakByWordWrapping];
        _msgL.text = self.dynamic.msg;
        _msgL.backgroundColor = [UIColor whiteColor];
        if (msgMinSize.height==msgSize.height){
            _msgL.frame = CGRectMake(60, origin, msgMinSize.width, msgMinSize.height);
            origin+=(msgMinSize.height+10);
        }
        if (msgMinSize.height<msgSize.height) {
            if (msgSize.height<150) {
                if(self.dynamic.ifZhankaied == 0)
                {
                    _msgL.frame = CGRectMake(60, origin, msgMinSize.width, msgMinSize.height);
                    origin+=(msgMinSize.height+10);
                    quanwenB.frame = CGRectMake(60, origin, 30, 15);
                    origin+=25;
                }else{
                     _msgL.frame = CGRectMake(60, origin, msgSize.width, msgSize.height);
                    origin+=(msgSize.height+10);
                    quanwenB.frame = CGRectMake(60, origin, 30, 15);
                    origin+=25;
                }
                
            }else{
                _msgL.backgroundColor= [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                _msgL.frame = CGRectMake(60, 40, 240, 15);
                pushB.frame = _msgL.frame;
                origin+=25;
            }
        }
        if (self.dynamic.smallImage.count>=1&&self.dynamic.smallImage.count<=3) {
            int originX = 60;
            for (int i = 0; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 70, 70);
                originX+=80;
            }
            origin+=80;
        }else if(self.dynamic.smallImage.count>3&&self.dynamic.smallImage.count<=6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 70, 70);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 70, 70);
                originX+=80;
            }
            origin+=160;
        }else if(self.dynamic.smallImage.count>6){
            int originX = 60;
            for (int i = 0; i<3; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin, 70, 70);
                originX+=80;
            }
            originX = 60;
            for (int i = 3; i<6; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+80, 70, 70);
                originX+=80;
            }
            originX = 60;
            for (int i = 6; i<self.dynamic.smallImage.count; i++) {
                EGOImageButton * a = self.imageViews[i];
                a.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://123.178.27.74/pet/static/%@",self.dynamic.smallImage[i]]];
                a.frame = CGRectMake(originX, origin+160, 70, 70);
                originX+=80;
            }
            origin+=240;
        }
    }
    CGSize timeSize = [self.dynamic.submitTime sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _timeL.text = self.dynamic.submitTime;
    _timeL.frame = CGRectMake(60, origin, timeSize.width, timeSize.height);
    moveB.frame = CGRectMake(290, origin, 20, 10);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showButton
{
    [self.viewC performSelector:@selector(showButton:) withObject:self];
}
-(void)PersonDetail
{
    PersonDetailViewController*personVC = [[PersonDetailViewController alloc]init];
    [self.viewC.navigationController pushViewController:personVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];
}
-(void)quanwen
{
    if (_msgL.frame.size.height<msgSize.height) {
        _msgL.frame = CGRectMake(70, 40, msgSize.width, msgSize.height);
        self.dynamic.rowHigh+=(msgSize.height-msgMinSize.height);
        self.dynamic.ifZhankaied = 1;
        [quanwenB setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        _msgL.frame = CGRectMake(70, 40, msgMinSize.width, msgMinSize.height);
        self.dynamic.ifZhankaied = 0;
        self.dynamic.rowHigh-=(msgSize.height-msgMinSize.height);
        [quanwenB setTitle:@"展开" forState:UIControlStateNormal];
    }
    [(UITableView*)self.superview reloadData];
}
-(void)pushQuanwen
{
    FullTextViewController* fullTextVC = [[FullTextViewController alloc]init];
    fullTextVC.text = _msgL.text;
    [self.viewC.navigationController pushViewController:fullTextVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];
}
@end
