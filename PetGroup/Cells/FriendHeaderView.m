//
//  FriendHeaderView.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-14.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendHeaderView.h"

@implementation FriendHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization
//        UIButton * searchB = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchB.frame = CGRectMake(0, 0, 320, 45);
//        [searchB setBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
//        [searchB addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:searchB];
        float diffH = [Common diffHeight:nil];
        UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
        bg.image = diffH==0.0f?[UIImage imageNamed:@"biaoti"]:[UIImage imageNamed:@"biaoti2"];
        [self addSubview:bg];
        UILabel* titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 200, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.text = @"朋友圈";
        titleL.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleL];
    }
    return self;
}
-(void)selector
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectSearchBAtFriendHeaderView:)]) {
        [self.delegate didSelectSearchBAtFriendHeaderView:self];
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
