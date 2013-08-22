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
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgV];
        self.backgroudImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV addSubview:self.backgroudImageV];
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [bgV addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 110, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [bgV addSubview:self.nameLabel];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        self.distLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 110, 20)];
        [self.distLabel setTextAlignment:NSTextAlignmentLeft];
        [self.distLabel setTextColor:[UIColor grayColor]];
        [bgV addSubview:self.distLabel];
        [self.distLabel setBackgroundColor:[UIColor clearColor]];
        self.sigBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(182, 10, 118.5, 50)];
        [self.sigBgImgV setImage:[UIImage imageNamed:@"asigbg.png"]];
        self.sigBgImgV.alpha = 0.6;
        [bgV addSubview:self.sigBgImgV];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(187, 15, 108.5, 40)];
        [self.signatureLabel setTextColor:[UIColor grayColor]];
        [self.signatureLabel setFont:[UIFont systemFontOfSize:14]];
        [self.signatureLabel setAdjustsFontSizeToFitWidth:YES];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
        [self.signatureLabel setNumberOfLines:0];
        [self.signatureLabel setLineBreakMode:UILineBreakModeCharacterWrap];

        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(306, 28.7, 8.5, 12.5)];
        [arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
        [bgV addSubview:arrow];
        [bgV addSubview:self.signatureLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
