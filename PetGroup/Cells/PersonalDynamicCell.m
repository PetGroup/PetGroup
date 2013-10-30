//
//  PersonalDynamicCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-11.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PersonalDynamicCell.h"
#import "EGOImageButton.h"
#import "OHAttributedLabel.h"

@interface PersonalDynamicCell ()

@property (nonatomic,retain)UIView* backView;
@property (nonatomic,retain)UIImageView * zanImageV;
@property (nonatomic,retain)UILabel* timeL;
@property (nonatomic,retain)OHAttributedLabel* transmitMsgL;
@property (nonatomic,retain)OHAttributedLabel* msgL;
@property (nonatomic,retain)NSArray* imageButtons;
@end

@implementation PersonalDynamicCell
+(CGFloat)heightForRowWithDynamic:(Dynamic*)dynamic;
{
    CGFloat height = 10;
    if (!dynamic.ifTransmitMsg) {
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height += (msgSize.height+10);
    }else{
        CGSize size =[dynamic.transmitMsg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height+=(size.height+5);
        CGSize msgSize = [dynamic.msg sizeConstrainedToSize:CGSizeMake(300, 200)];
        height+=(msgSize.height+10);
    }
    if (dynamic.smallImage.count>=1&&dynamic.smallImage.count<=3) {
        height+=85;
    }else if(dynamic.smallImage.count>3&&dynamic.smallImage.count<=6){
        height+=165;
    }else if(dynamic.smallImage.count>6){
        height+=245;
    }
    return height;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:_backView];
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 9; i++) {
            EGOImageButton * a = [[EGOImageButton alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [self.contentView addSubview:a];
            a.tag = 1000+i;
            [a addTarget:self action:@selector(loadBagImage:)  forControlEvents:UIControlEventTouchUpInside];
            [arr addObject:a];
        }
        self.imageButtons = arr;
        
        self.timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeL];
        
        self.transmitMsgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _transmitMsgL.backgroundColor = [UIColor clearColor];
        _transmitMsgL.numberOfLines = 0;
        [self.contentView addSubview:_transmitMsgL];
        
        self.msgL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _msgL.backgroundColor = [UIColor clearColor];
        _msgL.numberOfLines = 0;
        [self.contentView addSubview:_msgL];
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   
}
#pragma mark - button action

@end
