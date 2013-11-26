//
//  BusinessCell.m
//  PetGroup
//
//  Created by wangxr on 13-11-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "BusinessCell.h"
#import "EGOImageView.h"
@interface BusinessCell ()
@property(nonatomic,retain)EGOImageView*businessImageView;//商家图片
@property(nonatomic,retain)UILabel*nameLabel;//商家名字
@property(nonatomic,retain)UILabel*reviewCountLabel;//商家的点评量
@property(nonatomic,retain)UILabel*addressLabel;//商家地址
@property(nonatomic,retain)UILabel*categroyLabel;//商家所属分类
@property(nonatomic,assign)int hasDeall;//商家是否有团购，0没有，1有
@property(nonatomic,assign)int hasCoupons;//商家是否有优惠券，0没有，1有
@property(nonatomic,assign)float starCount;//商家的星级
@property(nonatomic,retain)UILabel*distanceLabel;
@end
@implementation BusinessCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
