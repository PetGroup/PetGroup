//
//  PetProfileCell.m
//  PetGroup
//
//  Created by Tolecen on 13-9-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PetProfileCell.h"

@implementation PetProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 185, 20)];
        self.describeLabel.textAlignment = NSTextAlignmentRight;
        [self.describeLabel setBackgroundColor:[UIColor clearColor]];
        [self.describeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.describeLabel setNumberOfLines:0];
        [self.describeLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        [self.contentView addSubview:self.describeLabel];
        
        UIImageView * arrow = [[UIImageView alloc] initWithFrame:CGRectMake(287, 13.75, 8.5, 12.5)];
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
