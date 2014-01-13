//
//  WithContenSubjectCell.m
//  PetGroup
//
//  Created by wangxr on 14-1-2.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "WithContenSubjectCell.h"
#import "EGOImageView.h"

@interface WithContenSubjectCell ()
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel* titleL;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)UILabel* contentL;
@end
@implementation WithContenSubjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        self.titleL = [[UILabel alloc]init];
        _titleL.backgroundColor = [UIColor clearColor];
        _titleL.numberOfLines = 0;
        _titleL.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleL];
        self.timeL = [[UILabel alloc]init];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        self.imageV = [[EGOImageView alloc]init];
        _imageV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_imageV];
        self.contentL = [[UILabel alloc]init];
        _contentL.backgroundColor = [UIColor clearColor];
        _contentL.textColor = [UIColor grayColor];
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self.contentView addSubview:_contentL];
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 270, 278, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:lineV];
        UILabel * readL = [[UILabel alloc]initWithFrame:CGRectMake(10, 275, 100, 20)];
        readL.backgroundColor = [UIColor clearColor];
        readL.font = [UIFont systemFontOfSize:14];
        readL.text = @"阅读全文";
        [self.contentView addSubview:readL];
        UIImageView* duckIM = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 40, 270, 40, 40)];
        duckIM.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:duckIM];
        
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
    _titleL.frame = CGRectMake((contentSize.width - 280)/2, 0, 280, 40);
    _timeL.frame = CGRectMake((contentSize.width - 280)/2, 40, 280, 20);
    _imageV.frame = CGRectMake((contentSize.width - 280)/2, 60, 280, 156);
    _contentL.frame = CGRectMake((contentSize.width - 280)/2, 220, 280, 45);
    _titleL.text = _subject.title;
    _timeL.text = [_subject.time substringToIndex:10];
    _imageV.imageURL = _subject.imageURL;
    _contentL.text = _subject.content;
    
}
@end
