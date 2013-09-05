//
//  HostInfoCell.m
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "HostInfoCell.h"

@implementation HostInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [self.contentView addSubview:self.nameLabel];
        self.genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 44, 10, 10)];
        [self.contentView addSubview:self.genderIV];
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 60, 20)];
        self.ageLabel.backgroundColor = [UIColor clearColor];
        self.ageLabel.textColor = [UIColor grayColor];
        self.ageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.ageLabel];
        self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 130, 20)];
        [self.regionLabel setTextAlignment:NSTextAlignmentRight];
        self.regionLabel.textColor = [UIColor grayColor];
        self.regionLabel.font = [UIFont systemFontOfSize:14];
        self.regionLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.regionLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
