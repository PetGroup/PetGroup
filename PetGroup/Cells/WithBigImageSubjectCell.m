//
//  WithBigImageSubjectCell.m
//  PetGroup
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "WithBigImageSubjectCell.h"
#import "EGOImageView.h"

@interface WithBigImageSubjectCell ()
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel* titleL;
@property (nonatomic,retain)UIView* blackV;
@end
@implementation WithBigImageSubjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        // Initialization code
        self.imageV = [[EGOImageView alloc]init];
        [self.contentView addSubview:_imageV];
        self.blackV = [[UIView alloc]init];
        _blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.contentView addSubview:_blackV];
        self.titleL = [[UILabel alloc]init];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = [UIColor whiteColor];
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
    CGSize size = [_subject.title sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(270, 40) lineBreakMode:NSLineBreakByWordWrapping];
    _imageV.frame = CGRectMake((contentSize.width - 280)/2, 0, 280, 156);
    if (size.height>20) {
        _blackV.frame = CGRectMake((contentSize.width - 280)/2, 106, 280, 50);
        _titleL.frame = CGRectMake((contentSize.width - 280)/2+5, 111, 270, 40);
    }else{
        _blackV.frame = CGRectMake((contentSize.width - 280)/2, 126, 280, 30);
        _titleL.frame = CGRectMake((contentSize.width - 280)/2+5, 131, 270, 20);
    }
    
    _titleL.text = _subject.title;
    _imageV.imageURL = _subject.imageURL;
}
@end
