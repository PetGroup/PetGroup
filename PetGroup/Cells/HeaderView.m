//
//  HeaderView.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "HeaderView.h"
@interface HeaderView ()

@end
@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView * bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
        bg.image = [UIImage imageNamed:@"biaoti"];
        [self addSubview:bg];
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 100, 20)];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_titleL];
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
