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
@property(nonatomic,retain)UILabel*distanceLabel;//距离
@property(nonatomic,retain)UIImageView* starImage;//商家的星级
@end
@implementation BusinessCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.businessImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"dianping.png"]];
        _businessImageView.frame = CGRectMake(10, 10, 118.828 , 85.488);
        [self.contentView addSubview:_businessImageView];
        _nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(138, 10, 190 , 20)];
        _nameLabel.font=[UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:_nameLabel];
        self.starImage = [[UIImageView alloc]initWithFrame:CGRectMake(138, 33, 84,16)];
        [self.contentView addSubview:_starImage];
        
        self.reviewCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(230.968, 34.214, 44.374 , 13.123)];
        _reviewCountLabel.font=[UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_reviewCountLabel];
        
        self.addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(136.084, 54.47, 190 , 15.509)];
        _addressLabel.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_addressLabel];
        
        self.categroyLabel=[[UILabel alloc] initWithFrame:CGRectMake(136.084, 77.235, 52 , 15.509)];
        _categroyLabel.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_categroyLabel];
        
        self.distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(198.968, 77.235, 100 , 15.509)];
        _distanceLabel.font=[UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_distanceLabel];
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
    _businessImageView.imageURL = self.business.sPhotoURL;
    _nameLabel.text = self.business.name;
    if (self.business.avgRating==0) {
        _starImage.image = [UIImage imageNamed:@"star_16_0.png"];
    }else if (self.business.avgRating==1) {
        _starImage.image = [UIImage imageNamed:@"star_16_1.png"];
        
    }else if (self.business.avgRating==2) {
        _starImage.image = [UIImage imageNamed:@"star_16_2.png"];
        
    }else if (self.business.avgRating==3) {
        _starImage.image = [UIImage imageNamed:@"star_16_3.png"];
        
    }else if (self.business.avgRating==3.5) {
        _starImage.image = [UIImage imageNamed:@"star_16_35.png"];
        
    }else if (self.business.avgRating==4) {
        _starImage.image = [UIImage imageNamed:@"star_16_4.png"];
        
    }else if (self.business.avgRating==4.5) {
        _starImage.image = [UIImage imageNamed:@"star_16_45.png"];
        
    }else {
        _starImage.image = [UIImage imageNamed:@"star_16_5.png"];
    }
    _reviewCountLabel.text =[ NSString stringWithFormat:@"评论:%d", self.business.reviewCount ];
    NSMutableString *regions = [[NSMutableString alloc]init];
    for (NSString* a in self.business.regions) {
        [regions appendString:a];
        if (![a isEqual:[self.business.regions lastObject]]) {
            [regions appendString:@"/"];
        }
    }
    _addressLabel.text = regions;
    _categroyLabel.text = [self.business.categories lastObject];
    _distanceLabel.text=[NSString stringWithFormat:@"%dm",self.business.distance];
}
@end
