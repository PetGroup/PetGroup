//
//  ButtonCell.m
//  PetGroup
//
//  Created by Tolecen on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        float diffH = [Common diffHeight:nil];
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        diffH==0.0f?[self.saveBtn setFrame:CGRectMake(0, 0, 300, 40)]:[self.saveBtn setFrame:CGRectMake(0, 0, 320, 40)];
        diffH==0.0f?[self.saveBtn setBackgroundImage:[UIImage imageNamed:@"brownlong-normal"] forState:UIControlStateNormal]:[self.saveBtn setBackgroundColor:[UIColor orangeColor]];
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.saveBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
