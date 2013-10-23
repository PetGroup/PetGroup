//
//  FooterView.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
        bg.image = [UIImage imageNamed:@"footer_bg"];
        [self addSubview:bg];
        
        self.unfoldB = [UIButton buttonWithType:UIButtonTypeCustom];
        _unfoldB.frame = CGRectMake(267, 0, 48, 19);
        [_unfoldB setBackgroundImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
        [_unfoldB setHighlighted:NO];
        [_unfoldB addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unfoldB];
    }
    return self;
}
-(void)selector
{
    [_unfoldB setHighlighted:NO];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(footerView: didSelectUnfoldBAtIndexPath:)]) {
        [self.delegate footerView:self didSelectUnfoldBAtIndexPath:self.indexPath];
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
