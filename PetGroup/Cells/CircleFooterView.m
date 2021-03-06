//
//  CircleFooterView.m
//  PetGroup
//
//  Created by wangxr on 13-11-27.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleFooterView.h"

@implementation CircleFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button addTarget:self action:@selector(zhankai) forControlEvents:UIControlEventTouchUpInside];
        _button.frame = CGRectMake(140, 0, 40, 30);
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        UIView * bview = [[UIView alloc]init];
        bview.backgroundColor = [UIColor whiteColor];
        self.backgroundView = bview;
    }
    return self;
}
-(void)zhankai
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(circleFooterViewPressButtonWithIndexPath:)])
    {
        [self.delegate circleFooterViewPressButtonWithIndexPath:self.section];
    }
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
