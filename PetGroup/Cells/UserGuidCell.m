//
//  UserGuidCell.m
//  PetGroup
//
//  Created by wangxr on 13-12-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "UserGuidCell.h"

@implementation UserGuidCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_bgView];
        self.logeV = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        _logeV.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_logeV];
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(5, 68, frame.size.width-10, 13)];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.adjustsFontSizeToFitWidth = YES;
        _titleL.minimumScaleFactor = 0.0;
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
