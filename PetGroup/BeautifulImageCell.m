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
        self.bottenV = [[UIView alloc]init];
        _bottenV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:_bottenV];
        self.titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.textColor = [UIColor whiteColor];
        [self addSubview:_titleL];
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        [zanB setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [zanB addTarget:self action:@selector(zanAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zanB];
        
    }
    return self;
}
- (void)layoutSubviews {
    self.imageView.frame = CGRectInset(self.bounds, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
    CGSize size = [_titleL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 20) lineBreakMode:NSLineBreakByWordWrapping];
    self.titleL.frame = CGRectMake(30 ,self.frame.size.height-size.height-3,100,size.height);
    zanB.frame = CGRectMake(0, _titleL.frame.origin.y- 10, 30, 30);
    _bottenV.frame = CGRectMake(kTMPhotoQuiltViewMargin, self.bounds.size.height - 30 - kTMPhotoQuiltViewMargin,self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin, 30);
}
-(void)zanAction
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(beautifulImageCellPressZanButtonAtIndexPath:)]) {
        [self.delegate beautifulImageCellPressZanButtonAtIndexPath:self.indexPath];
    }
}
@end
