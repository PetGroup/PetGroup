//
//  BeautifulImageCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "BeautifulImageCell.h"
const CGFloat kTMPhotoQuiltViewMargin = 0;
@interface BeautifulImageCell()
{
    UIButton* zanB;
}
@property(nonatomic,retain)UIView * bottenV;
@end
@implementation BeautifulImageCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView = [[EGOImageView alloc]init];
        [self addSubview:_imageView];
        self.imageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.bottenV = [[UIView alloc]init];
        _bottenV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:_bottenV];
        self.titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textColor = [UIColor whiteColor];
        [self addSubview:_titleL];
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        [zanB setBackgroundImage:[UIImage imageNamed:@"newZan.png"] forState:UIControlStateNormal];
        [zanB addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zanB];
        
    }
    return self;
}
- (void)layoutSubviews {
    self.imageView.frame = CGRectInset(self.bounds, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    CGSize size = [_titleL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 20) lineBreakMode:NSLineBreakByWordWrapping];
    self.titleL.frame = CGRectMake(30 ,self.frame.size.height-size.height-6,100,size.height);
    zanB.frame = CGRectMake(0, self.frame.size.height-size.height-13, 30, 30);
    _bottenV.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - 30 - kTMPhotoQuiltViewMargin,self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin, 30);
}
-(void)zanAction:(UIButton *)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(beautifulImageCellPressZanButtonAtIndexPath:)]) {
        sender.enabled = NO;
        UIImageView * dingShow = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.titleL.frame.origin.y, 50, 25)];
        [dingShow setImage:[UIImage imageNamed:@"dingShow.png"]];
        [self addSubview:dingShow];
        [dingShow setAlpha:1];
        [UIView animateWithDuration:0.5 animations:^{
            [dingShow setFrame:CGRectMake(dingShow.frame.origin.x-22.5, dingShow.frame.origin.y-25, 100, 50)];
        } completion:^(BOOL finished) {
            [dingShow setFrame:CGRectMake(dingShow.frame.origin.x+12.5, dingShow.frame.origin.y+25, 50, 25)];
            [dingShow removeFromSuperview];
            sender.enabled = YES;
        }];
        [self.delegate beautifulImageCellPressZanButtonAtIndexPath:self.indexPath];
    }
}
//-(void)showDingShow
//{
//    [dingShow setAlpha:1];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [dingShow setFrame:CGRectMake(dingShow.frame.origin.x-12.5, dingShow.frame.origin.y-25, 100, 50)];
//    [dingShow setAlpha:0];
//    [UIView commitAnimations];
//    [self performSelector:@selector(resetDingShow) withObject:nil afterDelay:0.5];
//}
//
//-(void)resetDingShow
//{
//    [dingShow setFrame:CGRectMake(dingShow.frame.origin.x+12.5, dingShow.frame.origin.y+25, 50, 25)];
//}
@end
