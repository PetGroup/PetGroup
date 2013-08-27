//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIButton* moveB = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveB setBackgroundImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
    moveB.frame = CGRectMake(280, 30, 20, 10);
    [self.contentView addSubview:moveB];
    [moveB addTarget:self action:@selector(showButton) forControlEvents:UIControlEventTouchUpInside];
    self.contentView.frame = CGRectMake(0, 0, 320, 99);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showButton
{
    [self.viewC performSelector:@selector(showButton:) withObject:self];
}
@end
