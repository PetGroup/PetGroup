//
//  MyInfoCell.m
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 110, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:self.nameLabel];
        //        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 200, 20)];
        [self.signatureLabel setTextColor:[UIColor grayColor]];
        [self.signatureLabel setFont:[UIFont systemFontOfSize:14]];
        [self.signatureLabel setAdjustsFontSizeToFitWidth:YES];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.signatureLabel];
        
        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(286, 28.7, 8.5, 12.5)];
        [arrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
        [self.contentView addSubview:arrow];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
