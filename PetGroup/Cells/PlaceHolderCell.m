//
//  PlaceHolderCell.m
//  PetGroup
//
//  Created by admin on 13-11-8.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PlaceHolderCell.h"
@interface PlaceHolderCell ()
@property (nonatomic,retain)UILabel*titleL;
@end
@implementation PlaceHolderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 240, 50)];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.numberOfLines = 0;
        [self.contentView addSubview:_titleL];
    }
    return self;
}
-(void)layoutSubviews
{
    CGSize size =  [_placeHolderString sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 200) lineBreakMode:NSLineBreakByWordWrapping];
    _titleL.frame = CGRectMake(10, 10, 300, size.height);
    _titleL.text = _placeHolderString;
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
