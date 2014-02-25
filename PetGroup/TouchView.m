//
//  TouchView.m
//  PetGroup
//
//  Created by wangxr on 14-2-25.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate&&[self.delegate respondsToSelector:@selector(TouchViewBeginTouch:)]) {
        [_delegate TouchViewBeginTouch:self];
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
