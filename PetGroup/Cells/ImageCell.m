//
//  ImageCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-25.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()

@end
@implementation ImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageV = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholderpet"]];
        _imageV.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.contentView addSubview:_imageV];
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
