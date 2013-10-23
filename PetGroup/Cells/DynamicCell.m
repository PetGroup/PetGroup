//
//  DynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-8-22.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"

@interface DynamicCell ()

{
    UIButton* nameB;
    EGOImageButton* headB;
    UIButton* zanB;
    UIButton* replyB;
    UIButton* zhuanfaB;
    
}
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@property (nonatomic,retain)NSArray* imageButtons;
@end
@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        nameB = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [nameB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:nameB];
        nameB.titleLabel.font = [UIFont systemFontOfSize:16];
        headB = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"moren_people.png"]];
        [headB addTarget:self action:@selector(PersonDetail) forControlEvents:UIControlEventTouchUpInside];
        headB.tintColor = [UIColor grayColor];
        [self.contentView addSubview:headB];
        
       
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [a addTarget:self action:@selector(loadBagImage)  forControlEvents:UIControlEventTouchUpInside];
            [arr addObject:a];
        }
        self.imageButtons = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_msgL];
        
        zanB = [UIButton buttonWithType:UIButtonTypeCustom];
        replyB = [UIButton buttonWithType:UIButtonTypeCustom];
        zhuanfaB = [UIButton buttonWithType:UIButtonTypeCustom];
        

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - button action


@end
