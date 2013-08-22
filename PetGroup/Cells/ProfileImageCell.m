//
//  ProfileImageCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-10.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ProfileImageCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation ProfileImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.pic1 = [[UIImageView alloc] initWithFrame:CGRectMake(70+20, 7.5, 45, 45)];
        [self.pic1 setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.pic1];
        self.pic1.layer.cornerRadius = 8;
        
        self.pic2 = [[UIImageView alloc] initWithFrame:CGRectMake(90+45+7.5, 7.5, 45, 45)];
        [self.pic2 setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.pic2];
        self.pic2.layer.cornerRadius = 8;
        
        self.pic3 = [[UIImageView alloc] initWithFrame:CGRectMake(142.5+45+7.5, 7.5, 45, 45)];
        [self.pic3 setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.pic3];
        self.pic3.layer.cornerRadius = 8;
        
        self.pic4 = [[UIImageView alloc] initWithFrame:CGRectMake(195+45+7.5, 7.5, 45, 45)];
        [self.pic4 setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.pic4];
        self.pic4.layer.cornerRadius = 8;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
