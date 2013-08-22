//
//  MyProfileCCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileCCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyProfileCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.layer.cornerRadius = 8;
        self.headImageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 120, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.nameLabel];
        
        UILabel * theAgeL = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 40, 20)];
        [theAgeL setText:@"年龄:"];
        [theAgeL setBackgroundColor:[UIColor clearColor]];
        [theAgeL setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:theAgeL];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 42, 40, 20)];
        [self.ageLabel setFont:[UIFont systemFontOfSize:14]];
        [self.ageLabel setBackgroundColor:[UIColor clearColor]];
        [self.ageLabel setText:@"0"];
        [self.contentView addSubview:self.ageLabel];
        
        
        self.bgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 280, 30)];
        [_bgV setImage:[UIImage imageNamed:@"mysigbg.png"]];
        [self.contentView addSubview:_bgV];
        
        UILabel * sigL = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 40, 20)];
        [sigL setText:@"特点:"];
        [sigL setBackgroundColor:[UIColor clearColor]];
        [sigL setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:sigL];
        
        self.featureLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 75, 200, 20)];
        self.featureLabel.numberOfLines = 0;
        [self.featureLabel setFont:[UIFont systemFontOfSize:15]];
        [self.featureLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.featureLabel];
        
        UILabel * kL = [[UILabel alloc] initWithFrame:CGRectMake(190, 17, 40, 20)];
        [kL setText:@"品种:"];
        [kL setBackgroundColor:[UIColor clearColor]];
        [kL setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:kL];
        
        self.kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 17, 60, 20)];
        [self.kindLabel setBackgroundColor:[UIColor clearColor]];
        self.kindLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.kindLabel];
        
        UILabel * kL2 = [[UILabel alloc] initWithFrame:CGRectMake(190, 42, 40, 20)];
        [kL2 setText:@"性别:"];
        [kL2 setBackgroundColor:[UIColor clearColor]];
        [kL2 setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:kL2];
        
        self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 42, 60, 20)];
        [self.genderLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.genderLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
