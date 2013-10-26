//
//  ReplyCell.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ReplyCell.h"
#import "Reply.h"
#import "ReplyComment.h"
#import "HeightCalculate.h"
#import "PersonDetailViewController.h"
#import "CustomTabBar.h"
#import "ParticularDynamicViewController.h"
@interface ReplyCell ()<UIAlertViewDelegate,UIActionSheetDelegate,OHAttributedLabelDelegate>
{
    UIActionSheet*delOrReplyReplyAction;
    UIActionSheet*delReplyAction;
}
@end
@implementation ReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.ohaL = [[OHAttributedLabel alloc]initWithFrame:CGRectZero];
        _ohaL.delegate = self;
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
    if ([self.theID isKindOfClass:[Reply class]]) {
        Reply* rel = (Reply*)self.theID;
        NSString* repS = [NSString stringWithFormat:@"%@:%@",rel.petUser.nickName,rel.msg];
        [_ohaL setDisplayText:repS WithCommentArray:@[@{@"nickName": rel.petUser.nickName,@"petUser":rel}] MaxWidth:240];
        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
        [_ohaL setFrame:CGRectMake(60 , 5, 240, size.height)];
    }
    if ([self.theID isKindOfClass:[ReplyComment class]]) {
        ReplyComment* recom = (ReplyComment*)self.theID;
        NSString* repS = [NSString stringWithFormat:@"%@回复%@:%@",recom.commentUserView.nickName,recom.replyUserView.nickName,recom.commentsMsg];
        [_ohaL setDisplayText:repS WithCommentArray:@[@{@"nickName": recom.commentUserView.nickName,@"petUser":recom},@{@"nickName": recom.replyUserView.nickName,@"petUser":recom}] MaxWidth:240];
        CGSize size = [HeightCalculate calSizeWithString:repS WithMaxWidth:240];
        [_ohaL setFrame:CGRectMake(60 , 5, 240, size.height)];
    }
    [self.contentView addSubview:_ohaL];
}
#pragma mark - OHAttributedLabel Delegate
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    return YES;
}
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldUserName:(NSString *)userName TheID:(id)theid theIndex:(int)theIndex
{
    HostInfo* hostInfo = nil;
    if (theIndex == 0) {
        if ([theid isKindOfClass:[Reply class]]) {
            hostInfo = ((Reply*)theid).petUser;
        }
        if ([theid isKindOfClass:[ReplyComment class]]) {
            hostInfo = ((ReplyComment*)theid).commentUserView;
        }
    }else{
        hostInfo = ((ReplyComment*)theid).replyUserView;
    }
    if ([hostInfo.userId integerValue] == [[[TempData sharedInstance] getMyUserID] integerValue]) {

        return YES;
    }
    PersonDetailViewController*personVC = [[PersonDetailViewController alloc]init];
    personVC.hostInfo = hostInfo;
    [self.viewC.navigationController pushViewController:personVC animated:YES];
    [self.viewC.customTabBarController hidesTabBar:YES animated:YES];
    
    return YES;
}

-(void)labelTouchedWithNickName:(NSString *)nickName TheID:(id)theID
{
//    if ([theID isKindOfClass:[Reply class]]) {
//        if ([((ParticularDynamicViewController*)self.viewC).dynamic.petUser.userId integerValue] == [[[TempData sharedInstance] getMyUserID]integerValue]&&[((Reply*)theID).petUser.userId integerValue] != [[[TempData sharedInstance] getMyUserID] integerValue]) {
//            delOrReplyReplyAction= [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复", nil];
//            [delOrReplyReplyAction showInView:self.superview];
//            return;
//        }
//        if ([((Reply*)theID).petUser.userId integerValue] == [[[TempData sharedInstance] getMyUserID] integerValue]) {
//            delReplyAction= [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
//            [delReplyAction showInView:self.superview];
//            return;
//        }
//    }
//    if ([theID isKindOfClass:[ReplyComment class]]) {
//        if ([((ParticularDynamicViewController*)self.viewC).dynamic.petUser.userId integerValue] == [[[TempData sharedInstance] getMyUserID] integerValue]&&[((ReplyComment*)theID).commentUserView.userId integerValue] != [[[TempData sharedInstance] getMyUserID] integerValue]) {
//            UIActionSheet* action = [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"回复", nil];
//            [action showInView:self.superview];
//            return;
//        }
//        if ([((ReplyComment*)theID).commentUserView.userId integerValue] == [[[TempData sharedInstance] getMyUserID] integerValue]) {
//            delReplyAction= [[UIActionSheet alloc]initWithTitle:@"你要做什么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
//            [delReplyAction showInView:self.superview];
//            return;
//        }
//    }
//    [self.viewC performSelector:@selector(recalledreply: cell:) withObject:theID withObject:self];
}
#pragma mark - OHAttributedLabel Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == delOrReplyReplyAction) {
        if (buttonIndex == 0) {
            UIAlertView*delReplyAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除该评论?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
            [delReplyAlert show];
        }
        if (buttonIndex == 1) {
            [self.viewC performSelector:@selector(recalledreply: cell:) withObject:_theID withObject:self];
        }
    }
    if (actionSheet ==delReplyAction) {
        if (buttonIndex == 0) {
            UIAlertView*delReplyAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定删除该评论?" delegate:self cancelButtonTitle:@"点错啦" otherButtonTitles:@"确定", nil];
            [delReplyAlert show];
        }
    }
    
}
#pragma mark - alert view delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 1) {
//        if ([_theID isKindOfClass:[Reply class]]) {
//            NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
//            NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//            long long a = (long long)(cT*1000);
//            [params setObject:((Reply*)_theID).replyID forKey:@"replyId"];
//            NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
//            [body setObject:@"1" forKey:@"channel"];
//            [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//            [body setObject:@"iphone" forKey:@"imei"];
//            [body setObject:params forKey:@"params"];
//            [body setObject:@"delReply" forKey:@"method"];
//            [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//            [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//            [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [((ParticularDynamicViewController*)self.viewC).dynamic.replyViews removeObject:self.theID];
//                ((ParticularDynamicViewController*)self.viewC).highArray  = [[NSMutableArray alloc]init];
//                for (int i = 0; i < ((ParticularDynamicViewController*)self.viewC).dynamic.replyViews.count; i++) {
//                    Reply* rel = ((ParticularDynamicViewController*)self.viewC).dynamic.replyViews[i];
//                    [((ParticularDynamicViewController*)self.viewC).highArray addObject:rel];
//                    for (int j = 0; j < rel.replyComments.count; j++) {
//                        ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
//                        [((ParticularDynamicViewController*)self.viewC).highArray addObject:recom];
//                    }
//                }
//                [(UITableView*)self.superview reloadData];
//            }];
//        }
//        if ([self.theID isKindOfClass:[ReplyComment class]]) {
//            Reply* theReply = nil;
//            for (Reply* rep in ((ParticularDynamicViewController*)self.viewC).dynamic.replyViews) {
//                for (ReplyComment * repcom in rep.replyComments) {
//                    if ([self.theID isEqual:repcom]) {
//                        theReply = rep;
//                    }
//                }
//            }
//            if (theReply) {
//                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
//                NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
//                long long a = (long long)(cT*1000);
//                [params setObject:((ReplyComment*)self.theID).replyCommentID forKey:@"replyCommonid"];
//                NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
//                [body setObject:@"1" forKey:@"channel"];
//                [body setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
//                [body setObject:@"iphone" forKey:@"imei"];
//                [body setObject:params forKey:@"params"];
//                [body setObject:@"delCommentReply" forKey:@"method"];
//                [body setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
//                [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//                [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self.viewC success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    [theReply.replyComments removeObject:self.theID];
//                    ((ParticularDynamicViewController*)self.viewC).highArray  = [[NSMutableArray alloc]init];
//                    for (int i = 0; i < ((ParticularDynamicViewController*)self.viewC).dynamic.replyViews.count; i++) {
//                        Reply* rel = ((ParticularDynamicViewController*)self.viewC).dynamic.replyViews[i];
//                        [((ParticularDynamicViewController*)self.viewC).highArray addObject:rel];
//                        for (int j = 0; j < rel.replyComments.count; j++) {
//                            ReplyComment* recom = (ReplyComment*)rel.replyComments[j];
//                            [((ParticularDynamicViewController*)self.viewC).highArray addObject:recom];
//                        }
//                    }
//                    [(UITableView*)self.superview reloadData];
//                }];
//            }
//            
//        }
//    }
}
@end
