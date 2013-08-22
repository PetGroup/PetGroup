//
//  KKMessageCell.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-16.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKMessageCell.h"

@implementation KKMessageCell

@synthesize senderAndTimeLabel;
@synthesize messageContentView;
@synthesize bgImageView;
@synthesize headImgV;
@synthesize headBtn,chattoHeadBtn;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //日期标签
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //居中显示
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
        senderAndTimeLabel.textAlignment = UITextAlignmentCenter;
        senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:senderAndTimeLabel];
        //背景图
        
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [headBtn setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:headBtn];
        
        chattoHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chattoHeadBtn setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:chattoHeadBtn];
        
        headImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:headImgV];
        
        bgImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgImageView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      //  [bgImageView setAdjustsImageWhenHighlighted:NO];
        [self.contentView addSubview:bgImageView];
        
        
        //聊天信息
        messageContentView = [[UILabel alloc] init];
        messageContentView.backgroundColor = [UIColor clearColor];
        //不可编辑
        //        messageContentView.editable = NO;
        //        messageContentView.scrollEnabled = NO;
        [messageContentView setNumberOfLines:0];
        [messageContentView setLineBreakMode:UILineBreakModeCharacterWrap];
        [messageContentView setFont:[UIFont boldSystemFontOfSize:13]];
        // [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
        NSLog(@"fffff%f",self.frame.size.height);
        

    }
    
    return self;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"sss");
}



@end
