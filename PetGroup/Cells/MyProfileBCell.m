//
//  MyProfileBCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileBCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyProfileBCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.layer.cornerRadius = 8;
        self.headImageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 30)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.nameLabel];
        
        UILabel * theAgeL = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 40, 20)];
        [theAgeL setText:@"年龄:"];
        [theAgeL setBackgroundColor:[UIColor clearColor]];
        [theAgeL setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:theAgeL];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 42, 40, 20)];
        [self.ageLabel setBackgroundColor:[UIColor clearColor]];
        [self.ageLabel setFont:[UIFont systemFontOfSize:14]];
        [self.ageLabel setText:@"0"];
        [self.contentView addSubview:self.ageLabel];
        
        self.genderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(150, 46, 12, 12)];
        [self.contentView addSubview:self.genderImageV];
        //[self.genderImageV setImage:[UIImage imageNamed:@"manicon.png"]];
        
//        UIImageView * loveBtn = [[UIImageView alloc] init];
//        [loveBtn setFrame:CGRectMake(235, 19, 15, 15)];
//        [loveBtn setImage:[UIImage imageNamed:@"loveit2.png"]];
//        [self.contentView addSubview:loveBtn];
//        
//        self.loveLabel = [[UILabel alloc] initWithFrame:CGRectMake(254.5, 15, 40, 20)];
//        [self.loveLabel setBackgroundColor:[UIColor clearColor]];
//        [self.loveLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.loveLabel setFont:[UIFont systemFontOfSize:12]];
//        [self.loveLabel setText:@"2223"];
//        [self.contentView addSubview:self.loveLabel];
        
        self.bgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 280, 30)];
        [_bgV1 setImage:[UIImage imageNamed:@"mysigbg.png"]];
        [self.contentView addSubview:_bgV1];
        
        UILabel * sigL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 20)];
        [sigL setText:@"签名:"];
        [sigL setBackgroundColor:[UIColor clearColor]];
        [sigL setFont:[UIFont systemFontOfSize:15]];
        [_bgV1 addSubview:sigL];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 200, 20)];
        self.signatureLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.signatureLabel.numberOfLines = 0;
        [self.signatureLabel setFont:[UIFont systemFontOfSize:15]];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
        [_bgV1 addSubview:self.signatureLabel];
        
        self.bgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 280, 30)];
        [_bgV2 setImage:[UIImage imageNamed:@"mysigbg.png"]];
        [self.contentView addSubview:_bgV2];
        
        UILabel * sigL2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 40, 20)];
        [sigL2 setText:@"爱好:"];
        [sigL2 setBackgroundColor:[UIColor clearColor]];
        [sigL2 setFont:[UIFont systemFontOfSize:15]];
        [self.bgV2 addSubview:sigL2];
        
        self.hobbyLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 200, 20)];
        self.hobbyLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.hobbyLabel.numberOfLines = 0;
        [self.hobbyLabel setFont:[UIFont systemFontOfSize:15]];
        [self.hobbyLabel setBackgroundColor:[UIColor clearColor]];
        [_bgV2 addSubview:self.hobbyLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
