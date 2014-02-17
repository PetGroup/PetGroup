//
//  QRCodeCell.m
//  PetGroup
//
//  Created by wangxr on 14-2-14.
//  Copyright (c) 2014年 Tolecen. All rights reserved.
//

#import "QRCodeCell.h"
@interface QRCodeCell ()
@property (nonatomic,retain)UILabel* IDLable;
@property (nonatomic,retain)UILabel* petLable;
@property (nonatomic,retain)UILabel* tilLable;
@end
@implementation QRCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 67.5, 67.5)];
        self.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
        imageV.image = [UIImage imageNamed:@"saomiaoICO"];
        [self.contentView addSubview:imageV];
        
        self.IDLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 230, 20)];
        _IDLable.backgroundColor = [UIColor clearColor];
        _IDLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_IDLable];
        self.petLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, 230, 20)];
        _petLable.backgroundColor = [UIColor clearColor];
        _petLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:_petLable];
        self.tilLable = [[UILabel alloc]initWithFrame:CGRectMake(90, 60, 230, 20)];
        _tilLable.backgroundColor = [UIColor clearColor];
        _tilLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_tilLable];
        
        UIView* lineV = [[UIView alloc]initWithFrame:CGRectMake(20, 89, 300, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.80 blue:0.80 alpha:1];
        [self.contentView addSubview:lineV];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    _IDLable.text = [NSString stringWithFormat:@"ID:%@",_RQCodeMsg[@"num"]];
    _petLable.text = [NSString stringWithFormat:@"宠物:%@  %@",_RQCodeMsg[@"petNickname"],_RQCodeMsg[@"petType"]];
    _tilLable.text = [NSString stringWithFormat:@"联系电话:%@",_RQCodeMsg[@"petOwnerTel"]];
}
@end
