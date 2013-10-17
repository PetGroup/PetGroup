//
//  FriendCircleCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-10-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleCell.h"
#import "EGOImageView.h"
@interface FriendCircleCell ()
@property (nonatomic,retain)EGOImageView* imageV;
@property (nonatomic,retain)UILabel* titleL;
@end
@implementation FriendCircleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
        self.imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _imageV.placeholderImage = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:_imageV];
        
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
    [super layoutSubviews];
    if (_dynamic.smallImage.count>0) {
        _imageV.hidden = NO;
        _imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[0]]];
        CGSize size = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:NSLineBreakByWordWrapping];
        _titleL.frame = CGRectMake(70, 10, 140, size.height);
    }else{
        _imageV.hidden = YES;
        _imageV.imageURL = [NSURL URLWithString:@""];
        CGSize size = [self.dynamic.msg sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(300, 50) lineBreakMode:NSLineBreakByWordWrapping];
        _titleL.frame = CGRectMake(10, 10, 300, size.height);
    }
    
    _titleL.text = _dynamic.msg;
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
