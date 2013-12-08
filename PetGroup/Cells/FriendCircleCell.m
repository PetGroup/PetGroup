//
//  FriendCircleCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-28.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "FriendCircleCell.h"
#import "EGOImageView.h"

@interface FriendCircleCell ()

@property (nonatomic,retain)UILabel* dynamicL;
@property (nonatomic,retain)EGOImageView* dynamicIV;

@end
@implementation FriendCircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        imageV.image = [UIImage imageNamed:@"headbg"];
        [self.contentView addSubview:imageV];
        
        UILabel*nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 80, 20)];
        nameL.text = @"好友动态";
        nameL.backgroundColor = [UIColor clearColor];
        nameL.textColor = [UIColor blackColor];
        nameL.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:nameL];
        
        self.dynamicIV = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"headbg"]];
        _dynamicIV.frame = CGRectZero;
        [self.contentView addSubview:_dynamicIV];
        
        self.dynamicL = [[UILabel alloc]init];
        _dynamicL.font = [UIFont systemFontOfSize:12];
        _dynamicL.backgroundColor = [UIColor clearColor];
        _dynamicL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_dynamicL];
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
    if (self.dynamic.smallImage.count>0) {
        _dynamicIV.frame = CGRectMake(70, 35, 30, 30);
        _dynamicIV.imageURL =[NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.dynamic.smallImage[0]]];
        _dynamicL.frame = CGRectMake(105, 40, 200, 20);
        _dynamicL.text = _dynamic.msg.string;
    }else
    {
        _dynamicIV.frame = CGRectZero;
        _dynamicL.frame = CGRectMake(70, 40, 230, 20);
        _dynamicL.text = _dynamic.msg.string;
    }
}
@end
