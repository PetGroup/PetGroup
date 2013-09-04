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
        self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveBtn setFrame:CGRectMake(0, 0, 300, 40)];
        [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"brownlong-normal"] forState:UIControlStateNormal];
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
