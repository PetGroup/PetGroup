//
//  ReplyListCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-24.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReplyListCell.h"

@interface ReplyListCell ()
@end
@implementation ReplyListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 5, 40,40)];
        _headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        [self.contentView addSubview:_headImageV];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 150, 20)];
        [self.contentView addSubview:_nameL];
        
        self.msgL = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, 150, 40)];
        [self.contentView addSubview:_msgL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(60, 75, 150, 20)];
        [self.contentView addSubview:_timeL];
        
        self.dynamicImageV = [[EGOImageView alloc]initWithFrame:CGRectMake(220, 5, 90,90)];
        _dynamicImageV.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
        [self.contentView addSubview:_dynamicImageV];
        
        self.dynamicL = [[UILabel alloc]initWithFrame:CGRectMake(220, 5, 90,90)];
        _dynamicL.numberOfLines = 0;
        [self.contentView addSubview:_dynamicL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
