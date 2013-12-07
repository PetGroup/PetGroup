//
//  CircleHeaderView.m
//  PetGroup
//
//  Created by wangxr on 13-12-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "CircleHeaderView.h"

@implementation CircleHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * bview = [[UIView alloc]init];
        bview.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.backgroundView = bview;
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 320, 20)];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleL];
    }
    return self;
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
