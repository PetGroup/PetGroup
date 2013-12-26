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
@synthesize ifRead,playAudioImageV;
@synthesize activityV;
@synthesize contentImgV;
@synthesize maskContentImgV;
@synthesize progressLabel;
@synthesize sendFailBtn;
@synthesize imgRadiusBG;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //日期标签
        self.backgroundColor = [UIColor clearColor];
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //居中显示
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
        senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
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
        
        headImgV = [[EGOImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:headImgV];
        
        bgImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgImageView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        //  [bgImageView setAdjustsImageWhenHighlighted:NO];
        [self.contentView addSubview:bgImageView];
        
        self.sendFailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.sendFailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.sendFailBtn setImage:[UIImage imageNamed:@"MessageSendFail"] forState:UIControlStateNormal];
        //  [bgImageView setAdjustsImageWhenHighlighted:NO];
        [self.contentView addSubview:self.sendFailBtn];
        
        //聊天信息
        messageContentView = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        messageContentView.backgroundColor = [UIColor clearColor];
        messageContentView.delegate = self;
//        messageContentView.backgroundColor = [UIColor clearColor];
//        //不可编辑
//        //        messageContentView.editable = NO;
//        //        messageContentView.scrollEnabled = NO;
//        [messageContentView setNumberOfLines:0];
//        [messageContentView setLineBreakMode:UILineBreakModeCharacterWrap];
//        [messageContentView setFont:[UIFont boldSystemFontOfSize:13]];
        // [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
        NSLog(@"fffff%f",self.frame.size.height);
        
        self.ifRead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [ifRead setImage:[UIImage imageNamed:@"redpot.png"]];
        [self.contentView addSubview:self.ifRead];
        
 
        
        
        self.playAudioImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.playAudioImageV.animationDuration=1.0;
        self.playAudioImageV.animationRepeatCount=0;
        [self.contentView addSubview:self.playAudioImageV];
        
        self.contentImgV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        self.contentImgV.layer.cornerRadius = 5;
//        self.contentImgV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.contentImgV];
        self.contentImgV.hidden = YES;
        
        self.maskContentImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.contentView addSubview:self.maskContentImgV];
        self.maskContentImgV.hidden = YES;
        self.maskContentImgV.backgroundColor = [UIColor blackColor];
        self.maskContentImgV.alpha = 0.65;
        
        self.imgRadiusBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.contentView addSubview:self.imgRadiusBG];
        self.imgRadiusBG.hidden = YES;
//        self.imgRadiusBG.backgroundColor = [UIColor blackColor];
//        self.imgRadiusBG.alpha = 0.65;
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //居中显示
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
//        self.progressLabel.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        self.progressLabel.shadowColor = [UIColor blackColor];
        self.progressLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.progressLabel];
        
        self.activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityV setFrame:CGRectMake(0, 0, 30, 30)];
        [self.contentView addSubview:self.activityV];
        
        
    }
    
    return self;
    
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
//	[self.visitedLinks addObject:objectForLinkInfo(linkInfo)];
	[attributedLabel setNeedsRecomputeLinksInText];
	
    if ([[UIApplication sharedApplication] canOpenURL:linkInfo.extendedURL])
    {
        // use default behavior
        return YES;
    }
    else
    {
        switch (linkInfo.resultType) {
            case NSTextCheckingTypeAddress:
                NSLog(@"%@",[linkInfo.addressComponents description]);
                break;
            case NSTextCheckingTypeDate:
                NSLog(@"%@",[linkInfo.date description]);
                break;
            case NSTextCheckingTypePhoneNumber:
                NSLog(@"%@",linkInfo.phoneNumber);
                break;
            default: {
//                NSString* message = [NSString stringWithFormat:@"You typed on an unknown link type (NSTextCheckingType %lld)",linkInfo.resultType];
//                [UIAlertView showWithTitle:@"Unknown link type" message:message];
                break;
            }
        }
        return NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"sss");
}



@end
