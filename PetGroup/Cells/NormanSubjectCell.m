//
//  NormanSubjectCell.m
//  PetGroup
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "NormanSubjectCell.h"
#import "EGOImageView.h"

@interface NormanSubjectCell ()
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel* titleL;
@end
@implementation NormanSubjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        UIView* lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:lineV];
        self.imageV = [[EGOImageView alloc]init];
        _imageV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_imageV];
        self.titleL = [[UILabel alloc]init];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize contentSize = self.contentView.frame.size;
    _titleL.frame = CGRectMake((contentSize.width - 280)/2, 10, 230, 40);
    _imageV.frame = CGRectMake(contentSize.width - 60, 5, 50, 50);
    _titleL.text = _subject.title;
    _imageV.imageURL = _subject.imageURL;
}
@end
