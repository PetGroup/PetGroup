//
//  MyProfileBtnCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MyProfileBtnCell.h"

@implementation MyProfileBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addBtn setFrame:CGRectMake(0, 0, 300, 40)];
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"brownlong-normal.png"] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"添加新宠物" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.contentView addSubview:self.addBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
