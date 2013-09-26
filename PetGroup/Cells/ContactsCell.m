//
//  ContactsCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell

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
        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [bgV addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 100, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [bgV addSubview:self.nameLabel];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];

        self.sigBgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(165, 15, 145, 30)];
        self.sigBgImgV.alpha = 0.6;
        [self.sigBgImgV setImage:[UIImage imageNamed:@"asigbg.png"]];
        [bgV addSubview:self.sigBgImgV];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 140, 30)];
        [self.signatureLabel setTextColor:[UIColor grayColor]];
        [self.signatureLabel setFont:[UIFont systemFontOfSize:14]];
//        [self.signatureLabel setAdjustsFontSizeToFitWidth:YES];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
        [self.signatureLabel setNumberOfLines:0];
        [self.signatureLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        
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
