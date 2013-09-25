//
//  NearByCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NearByCell.h"

@implementation NearByCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgV];
        self.backgroudImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV addSubview:self.backgroudImageV];
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
//        self.headImageV.layer.cornerRadius = 5;
//        self.headImageV.layer.masksToBounds=YES;
        [bgV addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 150, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [bgV addSubview:self.nameLabel];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];

//        self.sigBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(182, 10, 118.5, 50)];
//        [self.sigBgImgV setImage:[UIImage imageNamed:@"asigbg.png"]];
//        self.sigBgImgV.alpha = 0.6;
//        [bgV addSubview:self.sigBgImgV];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 108.5, 20)];
        [self.signatureLabel setTextColor:[UIColor clearColor]];
        [self.signatureLabel setFont:[UIFont systemFontOfSize:14]];
//        [self.signatureLabel setAdjustsFontSizeToFitWidth:YES];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
//        [self.signatureLabel setNumberOfLines:0];
//        [self.signatureLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        
//        UIImageView * biaoqian = [[UIImageView alloc] initWithFrame:CGRectMake(240, 10, 80, 23)];
//        [biaoqian setImage:[UIImage imageNamed:@"biaoqianNearby.png"]];
//        [bgV addSubview:biaoqian];
        
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
        self.genderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(240, 15, 12, 12)];
        [bgV addSubview:self.genderImgV];
        //[self.genderImgV setImage:[UIImage imageNamed:@"manicon.png"]];
       
//        UILabel * lineLabel= [[UILabel alloc] initWithFrame:CGRectMake(250, 14, 10, 15)];
//        [lineLabel setTextAlignment:NSTextAlignmentRight];
//        [lineLabel setFont:[UIFont systemFontOfSize:14]];
//        [lineLabel setText:@"|"];
//        [lineLabel setTextColor:[UIColor grayColor]];
//        [bgV addSubview:lineLabel];
//        [lineLabel setBackgroundColor:[UIColor clearColor]];
        
        self.distLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 55, 20)];
        [self.distLabel setTextAlignment:NSTextAlignmentRight];
        [self.distLabel setAdjustsFontSizeToFitWidth:YES];
        [self.distLabel setTextColor:[UIColor orangeColor]];
        [bgV addSubview:self.distLabel];
        [self.distLabel setBackgroundColor:[UIColor clearColor]];

        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(306, 48.7, 8.5, 12.5)];
        [arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
        [bgV addSubview:arrow];
        [bgV addSubview:self.signatureLabel];
        
        self.petOneImgV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 40, 30, 30)];
        [bgV addSubview:self.petOneImgV];
//        self.petOneImgV.layer.cornerRadius = 3;
//        self.petOneImgV.layer.masksToBounds=YES;
        
        self.petTwoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 40, 30, 30)];
        [bgV addSubview:self.petTwoImgV];
        
        self.petLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 63, 200, 20)];
        [self.petLabel setTextAlignment:NSTextAlignmentLeft];
        [self.petLabel setTextColor:[UIColor grayColor]];
        [self.petLabel setFont:[UIFont systemFontOfSize:14]];
        [self.petLabel setAdjustsFontSizeToFitWidth:YES];
        [bgV addSubview:self.petLabel];
        [self.petLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
