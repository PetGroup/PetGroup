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
        self.headImageV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 40,40)];
        _headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        [self.contentView addSubview:_headImageV];
        
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 190, 20)];
        _nameL.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_nameL];
        
        self.msgL = [[UILabel alloc]initWithFrame:CGRectMake(60, 35, 190, 15)];
        _msgL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_msgL];
        
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(60, 55, 190, 15)];
        _timeL.font = [UIFont systemFontOfSize:12];
        _timeL.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeL];
        
        self.dynamicImageV = [[EGOImageView alloc]initWithFrame:CGRectMake(250, 10, 60,60)];
        _dynamicImageV.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
        [self.contentView addSubview:_dynamicImageV];
        
        self.dynamicL = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 60,60)];
        _dynamicL.font = [UIFont systemFontOfSize:14];
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
