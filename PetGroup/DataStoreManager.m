//
//  DataStoreManager.m
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataStoreManager.h"
#import "TempData.h"
@implementation DataStoreManager
-(void)nothing
{}
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName
{
    [MagicalRecord cleanUp];
    [MagicalRecord setDefaultModelNamed:[NSString stringWithFormat:@"%@.momd",modelName]];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    NSLog(@"default database:%@,%@",dataBaseName,modelName);
}
#pragma mark - 存储消息相关
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype
{
    NSRange range = [[msg objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender;
    if (range.location!=NSNotFound) {
        sender = [[msg objectForKey:@"sender"] substringToIndex:range.location];
    }
    else
        sender = [msg objectForKey:@"sender"];
    NSRange range2 = [[msg objectForKey:@"receiver"] rangeOfString:@"@"];
    NSString * receiver;
    if (range2.location!=NSNotFound) {
        receiver = [[msg objectForKey:@"receiver"] substringToIndex:range2.location];
    }
    else
        receiver = [msg objectForKey:@"receiver"];
//    NSString * receiver = [msg objectForKey:@"receiver"];
    NSString * senderNickname = [msg objectForKey:@"nickname"];
    NSString * msgContent = [msg objectForKey:@"msg"];
    NSString * fileType = [msg objectForKey:@"fileType"]?[msg objectForKey:@"fileType"]:@"text";
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[msg objectForKey:@"time"] doubleValue]];
//    NSString * receiver;
//    if ([msg objectForKey:@"receicer"]) {
//        NSRange range2 = [[msg objectForKey:@"receicer"] rangeOfString:@"@"];
//        receiver = [[msg objectForKey:@"receicer"] substringToIndex:range2.location];
//    }
    
    //普通用户消息存储到DSCommonMsgs和DSThumbMsgs两个表里
    if ([sendertype isEqualToString:COMMONUSER]) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            if ([fileType isEqualToString:@"audio"]||[fileType isEqualToString:@"img"]) {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgContent==[c]%@",msgContent];
                
                DSCommonMsgs * commonMsg = [DSCommonMsgs MR_findFirstWithPredicate:predicate];
                if (!commonMsg){
                    commonMsg = [DSCommonMsgs MR_createInContext:localContext];
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
                    
                    DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
                    if (!thumbMsgs)
                        thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
                    thumbMsgs.sender = sender;
                    thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
                    if ([fileType isEqualToString:@"audio"]) {
                        thumbMsgs.msgContent = @"[语音]";
                    }
                    else if ([fileType isEqualToString:@"img"]){
                        thumbMsgs.msgContent = @"[图片]";
                    }
                    else
                        thumbMsgs.msgContent = msgContent;
                    thumbMsgs.sendTime = sendTime;
                    thumbMsgs.senderType = sendertype;
                    int unread = [thumbMsgs.unRead intValue];
                    thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
                }
//                commonMsg.msgID = msgID;
                commonMsg.readed = [msg objectForKey:@"readed"]?[msg objectForKey:@"readed"]:@"NO";
                commonMsg.msgType = fileType;
                commonMsg.sender = sender;
//                commonMsg.status = theStatus;
                commonMsg.senderNickname = senderNickname?senderNickname:@"";
                commonMsg.msgContent = msgContent?msgContent:@"";
                commonMsg.senTime = sendTime;
                commonMsg.receiver = receiver;
                
                
            }
            else{
                DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
                commonMsg.readed = @"YES";
                commonMsg.sender = sender;
                commonMsg.msgType = fileType;
                commonMsg.senderNickname = senderNickname?senderNickname:@"";
                commonMsg.msgContent = msgContent?msgContent:@"";
                commonMsg.senTime = sendTime;
                commonMsg.receiver = receiver;
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
                
                DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
                if (!thumbMsgs)
                    thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
                thumbMsgs.sender = sender;
                thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
                if ([fileType isEqualToString:@"audio"]) {
                    thumbMsgs.msgContent = @"[语音]";
                }
                else if ([fileType isEqualToString:@"img"]){
                    thumbMsgs.msgContent = @"[图片]";
                }
                else
                    thumbMsgs.msgContent = msgContent;
                thumbMsgs.sendTime = sendTime;
                thumbMsgs.senderType = sendertype;
                int unread = [thumbMsgs.unRead intValue];
                thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];

                
            }

            
            
            if (![self ifHaveThisFriend:sender]) {
                [self addFriendToLocal:sender];
            }
            
        }];
    }
    //公共账号消息存储到DSThumbPuclicMsgs和DSPublicMsgs里面
    else if ([sendertype isEqualToString:PUBLICACCOUNT]){
        
    }
    //订阅号信息存储到DSThumbSubscribedMsgs和DSSubscribedMsgs里面
    else if ([sendertype isEqualToString:SUBSCRIBEDACCOUNT]){
        
    }
    else if ([sendertype isEqualToString:SYSTEMNOTIFICATION]){
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"123456789"];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
            thumbMsgs.sender = @"123456789";
            thumbMsgs.senderNickname = @"圈子通知";
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
        }];
    }
    else if ([sendertype isEqualToString:NewSpecialSubject]){
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"bbs_special_subject"];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
            thumbMsgs.sender = @"bbs_special_subject";
            thumbMsgs.senderNickname = @"专题推荐";
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            NSLog(@"unread:%@",thumbMsgs.unRead);
        }];
    }
}
+(void)storeMyMessage:(NSDictionary *)message
{
    NSString * receicer = [message objectForKey:@"receiver"];
    NSString * sender = [message objectForKey:@"sender"];
    NSString * senderNickname = [message objectForKey:@"nickname"];
    NSString * msgContent = [message objectForKey:@"msg"];
    NSString * fileType = [message objectForKey:@"fileType"]?[message objectForKey:@"fileType"]:@"text";
    NSString * msgID = [message objectForKey:@"msgID"]?[message objectForKey:@"msgID"]:@"1";
    NSString * theStatus = [message objectForKey:@"status"]?[message objectForKey:@"status"]:@"sended";
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        if ([fileType isEqualToString:@"audio"]||[fileType isEqualToString:@"img"]) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgID==[c]%@",msgID];
            
            DSCommonMsgs * commonMsg = [DSCommonMsgs MR_findFirstWithPredicate:predicate];
            if (!commonMsg){
                commonMsg = [DSCommonMsgs MR_createInContext:localContext];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",receicer];
                
                DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
                if (!thumbMsgs)
                    thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
                thumbMsgs.sender = receicer;
                thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
                if ([fileType isEqualToString:@"audio"]) {
                    thumbMsgs.msgContent = @"[语音]";
                }
                else if ([fileType isEqualToString:@"img"]){
                    thumbMsgs.msgContent = @"[图片]";
                }
                else
                    thumbMsgs.msgContent = msgContent;
                thumbMsgs.sendTime = sendTime;
                thumbMsgs.senderType = COMMONUSER;
                int unread = [thumbMsgs.unRead intValue];
                thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            }
            commonMsg.msgID = msgID;
            commonMsg.readed = @"YES";
            commonMsg.msgType = fileType;
            commonMsg.sender = sender;
            commonMsg.status = theStatus;
            commonMsg.senderNickname = senderNickname?senderNickname:@"";
            commonMsg.msgContent = msgContent?msgContent:@"";
            commonMsg.senTime = sendTime;
            commonMsg.receiver = receicer;


        }
        else{
            DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
            commonMsg.sender = sender;
            commonMsg.senderNickname = senderNickname?senderNickname:@"";
            commonMsg.msgContent = msgContent?msgContent:@"";
            commonMsg.senTime = sendTime;
            commonMsg.receiver = receicer;
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",receicer];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
            thumbMsgs.sender = receicer;
            thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
            if ([fileType isEqualToString:@"audio"]) {
                thumbMsgs.msgContent = @"[语音]";
            }
            else if ([fileType isEqualToString:@"img"]){
                thumbMsgs.msgContent = @"[图片]";
            }
            else
                thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = COMMONUSER;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
        }
        
        
        
        
    }];

}
+(void)blankMsgUnreadCountForUser:(NSString *)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",username];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        if (thumbMsgs) {
            thumbMsgs.unRead = @"0";
        }
    }];
}
+(NSArray *)queryUnreadCountForCommonMsg
{
    NSMutableArray * unreadArray = [NSMutableArray array];
    NSArray * allUnreadArray = [DSThumbMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    for (int i = 0; i<allUnreadArray.count; i++) {
        [unreadArray addObject:[[allUnreadArray objectAtIndex:i]unRead]];
    }
    return unreadArray;
}
+(void)deleteThumbMsgWithSender:(NSString *)sender
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        [thumbMsgs MR_deleteInContext:localContext];
    }];
}
+(void)deleteMsgsWithSender:(NSString *)sender Type:(NSString *)senderType
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        if ([senderType isEqualToString:COMMONUSER]) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            [thumbMsgs MR_deleteInContext:localContext];
            NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"sender==[c]%@ OR receiver==[c]%@",sender,sender];
            NSArray * commonMsgs = [DSCommonMsgs MR_findAllWithPredicate:predicate2];
            for (int i = 0; i<commonMsgs.count; i++) {
                DSCommonMsgs * rH = [commonMsgs objectAtIndex:i];
                [rH MR_deleteInContext:localContext];
            }
        }

        
    }];
}
+(NSMutableArray *)qureyAllCommonMessages:(NSString *)username
{
    NSMutableArray * allMsgArray = [NSMutableArray array];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@ OR receiver==[c]%@",username,username];
    NSArray * commonMsgsArray = [DSCommonMsgs MR_findAllSortedBy:@"senTime" ascending:YES withPredicate:predicate];
    //取前20条...
    for (int i = (commonMsgsArray.count>20?(commonMsgsArray.count-20):0); i<commonMsgsArray.count; i++) {
        NSMutableDictionary * thumbMsgsDict = [NSMutableDictionary dictionary];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] sender] forKey:@"sender"];
        [thumbMsgsDict setObject:username forKey:@"receiver"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] readed]?[[commonMsgsArray objectAtIndex:i] readed]:@"YES" forKey:@"readed"];
        //        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] senderNickname] forKey:@"nickname"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] msgContent] forKey:@"msg"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] msgType]?[[commonMsgsArray objectAtIndex:i] msgType]:@"text" forKey:@"fileType"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] msgID]?[[commonMsgsArray objectAtIndex:i] msgID]:@"1" forKey:@"msgID"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] status]?[[commonMsgsArray objectAtIndex:i] status]:@"1" forKey:@"status"];
        if ([[thumbMsgsDict objectForKey:@"status"] isEqualToString:@"sending"]) {
            [thumbMsgsDict setObject:@"failed" forKey:@"status"];
        }
        NSDate * tt = [[commonMsgsArray objectAtIndex:i] senTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [thumbMsgsDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [allMsgArray addObject:thumbMsgsDict];
        
    }
    return allMsgArray;
}

+(void)deleteCommonMsg:(NSString *)content Time:(NSString *)theTime
{
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[theTime doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgContent==[c]%@ OR senTime==[c]%@",content,sendTime];
        DSCommonMsgs * commonMsgs = [DSCommonMsgs MR_findFirstWithPredicate:predicate];
        if (commonMsgs) {
            [commonMsgs MR_deleteInContext:localContext];
        }
     
    }];
}

+(void)refreshThumbMsgsAfterDeleteCommonMsg:(NSDictionary *)message ForUser:(NSString *)username ifDel:(BOOL)del
{
    NSString * msgContent = [message objectForKey:@"msg"];
    NSString * fileType = [message objectForKey:@"fileType"];
    fileType = fileType?fileType:@"text";
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate;

        predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",username];

        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];

        if (thumbMsgs){
            if (del) {
                [thumbMsgs MR_deleteInContext:localContext];
            }
            else
            {
                if ([fileType isEqualToString:@"audio"]) {
                    thumbMsgs.msgContent = @"[语音]";
                }
                else if ([fileType isEqualToString:@"img"]){
                    thumbMsgs.msgContent = @"[图片]";
                }
                else
                    thumbMsgs.msgContent = msgContent;
                thumbMsgs.sendTime = sendTime;
            }
        }
        
    }];
}

+(NSArray *)qureyAllThumbMessages
{
    NSMutableArray * allMsgArray = [NSMutableArray array];
    NSArray * thumbCommonMsgsArray = [DSThumbMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    for (int i = 0; i<thumbCommonMsgsArray.count; i++) {
        NSMutableDictionary * thumbMsgsDict = [NSMutableDictionary dictionary];
        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] sender] forKey:@"sender"];
//        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] senderNickname] forKey:@"nickname"];
        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] msgContent] forKey:@"msg"];
        NSDate * tt = [[thumbCommonMsgsArray objectAtIndex:i] sendTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [thumbMsgsDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [allMsgArray addObject:thumbMsgsDict];
        
    } 
    return allMsgArray;  
}

+(NSArray *)queryAllThumbPublicMsgs
{
    NSArray * thumbPublicMsgs = [DSThumbPublicMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    return thumbPublicMsgs;
}

+(NSDictionary *)queryLastPublicMsg
{
    NSArray * publicMsgs = [DSThumbPublicMsgs MR_findAllSortedBy:@"sendTime" ascending:YES];
    NSMutableDictionary * lastMsgDict = [NSMutableDictionary dictionary];
    [lastMsgDict setObject:@"公众账号" forKey:@"sender"];
    if (publicMsgs.count>0) {
        DSThumbPublicMsgs * lastRecHello = [publicMsgs lastObject];
        NSDate * tt = [lastRecHello sendTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%@给您发了一条消息",[lastRecHello senderNickname]] forKey:@"msg"];
    }
    else
    {
        NSTimeInterval uu = [[NSDate date] timeIntervalSince1970];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastMsgDict setObject:@"暂时还没有公众账号消息" forKey:@"msg"];
    }
    return lastMsgDict;
}

+(void)blankUnreadCountReceivedHellosForUser:(NSString *)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSReceivedHellos * dr = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (dr) {
            dr.unreadCount = @"0";
        }
        
    }];
}

+(NSArray *)queryAllReceivedHellos
{
    NSArray * rechellos = [DSReceivedHellos MR_findAllSortedBy:@"receiveTime" ascending:NO];
    NSMutableArray * hellosArray = [NSMutableArray array];
    for (int i = 0; i<rechellos.count; i++) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[[rechellos objectAtIndex:i] userName] forKey:@"userName"];
        [dict setObject:[[rechellos objectAtIndex:i] nickName] forKey:@"nickName"];
//        NSRange range=[[[rechellos objectAtIndex:i] headImgID] rangeOfString:@","];
//        if (range.location!=NSNotFound) {
////            NSArray *imageArray = [[[rechellos objectAtIndex:i] headImgID] componentsSeparatedByString:@","];
//            [dict setObject:[[rechellos objectAtIndex:i] headImgID] forKey:@"headImgID"];
//        }
//        else
        [dict setObject:[[rechellos objectAtIndex:i] headImgID] forKey:@"headImgID"];
        [dict setObject:[[rechellos objectAtIndex:i] addtionMsg] forKey:@"addtionMsg"];
        [dict setObject:[[rechellos objectAtIndex:i] acceptStatus] forKey:@"acceptStatus"];
        [dict setObject:[[rechellos objectAtIndex:i] receiveTime] forKey:@"receiveTime"];
        [dict setObject:[[rechellos objectAtIndex:i] unreadCount] forKey:@"unread"];
        [hellosArray addObject:dict];
    }
    return hellosArray;
}

+(NSDictionary *)qureyLastReceivedHello
{
    NSArray * rechellos = [DSReceivedHellos MR_findAllSortedBy:@"receiveTime" ascending:YES];
    NSMutableDictionary * lastHelloDict = [NSMutableDictionary dictionary];
    [lastHelloDict setObject:ZhaoHuLan forKey:@"sender"];
    if (rechellos.count>0) {
        DSReceivedHellos * lastRecHello = [rechellos lastObject];
        NSDate * tt = [lastRecHello receiveTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%@:%@",[lastRecHello nickName],[lastRecHello addtionMsg]] forKey:@"msg"];
    }
    else
    {
        NSTimeInterval uu = [[NSDate date] timeIntervalSince1970];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastHelloDict setObject:@"暂时还没有新朋友" forKey:@"msg"];
    }
    return lastHelloDict;
}

#pragma mark - 存储联系人相关
+(BOOL)ifHaveThisFriend:(NSString *)userName
{
    if (userName) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriends) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;

}

+(BOOL)ifFriendHaveNicknameAboutUser:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriends) {
        if (dFriends.nickName) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+(NSMutableArray *)querySections
{
    NSMutableArray * sectionArray = [NSMutableArray array];
    NSArray * nameIndexArray2 = [DSNameIndex MR_findAll];
    NSMutableArray * nameIndexArray = [NSMutableArray array];
    for (int i = 0; i<nameIndexArray2.count; i++) {
        DSNameIndex * di = [nameIndexArray2 objectAtIndex:i];
        if (![nameIndexArray containsObject:di.index]) {
            [nameIndexArray addObject:di.index];
        }
        
    }
    [nameIndexArray sortUsingSelector:@selector(compare:)];
    for (int i = 0; i<nameIndexArray.count; i++) {
        NSMutableArray * array = [NSMutableArray array];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",[nameIndexArray objectAtIndex:i]];
        NSArray * fri = [DSFriends MR_findAllSortedBy:@"nameKey" ascending:YES withPredicate:predicate];
        NSMutableArray * nameKeyArray = [NSMutableArray array];
        for (int i = 0; i<fri.count; i++) {
            NSString * thename = [[fri objectAtIndex:i]userName];
            NSString * nameK = [[fri objectAtIndex:i]nameKey];
            if (![thename isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                if (![nameKeyArray containsObject:nameK]) {
                    [nameKeyArray addObject:nameK];
                }
                
            }
        
        }
        [array addObject:[nameIndexArray objectAtIndex:i]];
        [array addObject:nameKeyArray];
        [sectionArray addObject:array];
    }
    return sectionArray;

}

+(NSMutableArray *)queryAllFriendsNickname
{
    NSMutableArray * array = [NSMutableArray array];
    NSArray * fri = [DSFriends MR_findAll];
    for (DSFriends * ggf in fri) {
        NSArray * arry = [NSArray arrayWithObjects:ggf.nickName?ggf.nickName:@"1",ggf.userName, nil];
        [array addObject:arry];
    }
    return array;
}

+(NSMutableDictionary *)queryFriendInfoByKey:(NSString *)nameKey
{
    NSString * nameK = nameKey;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameKey==[c]%@",nameK];
    DSFriends * df = [DSFriends MR_findFirstWithPredicate:predicate];
    NSString * userName = df.userName;
    NSString * nickName = df.nickName;
    NSString * remarkName = df.remarkName;
    NSString * headImg = [DataStoreManager queryFirstHeadImageForUser:userName];
    NSString * signature = df.signature;
//    if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
        NSMutableDictionary * friendDict = [NSMutableDictionary dictionary];
        [friendDict setObject:userName forKey:@"username"];
        [friendDict setObject:nickName?nickName:@"" forKey:@"nickname"];
        if (remarkName) {
            [friendDict setObject:remarkName forKey:@"displayName"];
        }
        else if(nickName){
            [friendDict setObject:nickName forKey:@"displayName"];
        }
        else
        {
            [friendDict setObject:userName forKey:@"displayName"];
        }
        [friendDict setObject:headImg?headImg:@"" forKey:@"img"];
        [friendDict setObject:signature?signature:@"" forKey:@"signature"];
        return friendDict;
//    }
}

+(NSMutableDictionary *)queryAllFriends
{
    NSArray * fri = [DSFriends MR_findAll];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser:userName];
        NSString * signature = [[fri objectAtIndex:i] signature];
        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * friendDict = [NSMutableDictionary dictionary];
            [friendDict setObject:userName forKey:@"username"];
            [friendDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (remarkName) {
                [friendDict setObject:remarkName forKey:@"displayName"];
            }
            else if(nickName){
                [friendDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [friendDict setObject:userName forKey:@"displayName"];
            }
            [friendDict setObject:headImg?headImg:@"" forKey:@"img"];
            [friendDict setObject:signature?signature:@"" forKey:@"signature"];
            [theDict setObject:friendDict forKey:nameK];
        }
    }
    return theDict;
}
+(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSString * dd = [[theName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    return dd;
}
+(void)addFriendToLocal:(NSString *)username
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:username forKey:@"username"];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"1" forKey:@"channel"];
    [postDict setObject:@"getUserinfo" forKey:@"method"];
    [postDict setObject:@"service.uri.pet_user" forKey:@"service"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:MACADDRESS andServiceName:LOCALACCOUNT error:nil] forKey:@"mac"];
    [postDict setObject:@"iphone" forKey:@"imei"];
    NSTimeInterval cT = [[NSDate date] timeIntervalSince1970];
    long long a = (long long)(cT*1000);
    [postDict setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"connectTime"];
    
    [NetManager requestWithURLStrNoController:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * recDict = responseObject;

        [DataStoreManager saveUserInfo:recDict];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

/*
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext];
            dFriend.userName = username;
            if (dFriend.nameKey.length<1) {
//                NSString * nameKey = [[DataStoreManager convertChineseToPinYin:username] stringByAppendingFormat:@"+%@",username];
//                dFriend.nameKey = nameKey;
//                dFriend.nameIndex = [[nameKey substringToIndex:1] uppercaseString];
//                NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",dFriend.nameIndex];
//                DSNameIndex * dFname = [DSNameIndex MR_findFirstWithPredicate:predicate2];
//                if (!dFname)
//                    dFname = [DSNameIndex MR_createInContext:localContext];
//                
//                dFname.index = dFriend.nameIndex;
            }
            
        }];
 */
}

+(void)updateFriendInfo:(NSDictionary *)userInfoDict ForUser:(NSString *)username
{
    NSString * nickName = [userInfoDict objectForKey:@"nickname"];
 

    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriend) {
            dFriend.userName = username;
            dFriend.nickName = nickName;
            dFriend.signature = [userInfoDict objectForKey:@"signature"];
        }

    }];

}
+(NSString *)getMyUserID
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        return dFriend.userId;
    }
    else
        return @"";
}
+(void)storeMyUserID:(NSString *)theID
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (!dFriend)
            dFriend = [DSFriends MR_createInContext:localContext];
        dFriend.userName = [SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
        dFriend.userId = theID;
    }];
}
+(NSString *)queryNickNameForUser:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"圈子通知";
    }
    else if ([userName isEqualToString:@"bbs_special_subject"]){
        return @"专题推荐";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        if (dFriend.nickName.length>1) {
            return dFriend.nickName;
        }
        else
            return dFriend.userName;
    }
    else
        return userName;
}
+(NSString *)queryFirstHeadImageForUser:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"no";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend.headImgID) {
        NSRange range=[dFriend.headImgID rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [dFriend.headImgID componentsSeparatedByString:@","];

            NSArray *arr = [[imageArray objectAtIndex:0] componentsSeparatedByString:@"_"];
            if (arr.count>1) {
                return [arr objectAtIndex:0];
            }
            else
                return [imageArray objectAtIndex:0];
        }
        else
        {
            NSArray *arr = [dFriend.headImgID componentsSeparatedByString:@"_"];
            if (arr.count>1) {
                return [arr objectAtIndex:0];
            }
            else
                return dFriend.headImgID;
        }
    }
    else
        return @"no";
}
#pragma mark - 存储个人信息
+(void)saveUserInfo:(NSDictionary *)myInfo
{
    NSString * myUserName = [myInfo objectForKey:@"username"];
    NSString * background = [self toString: [myInfo objectForKey:@"backgroundImg"]];
    NSString * nickName = [self toString:[myInfo objectForKey:@"nickname"]];
    NSString * gender = [self toString:[myInfo objectForKey:@"gender"]];
    NSString * headImgID = [self toString:[myInfo objectForKey:@"img"]];
    NSString * signature = [self toString:[myInfo objectForKey:@"signature"]];
    NSString * hobby = [self toString:[myInfo objectForKey:@"hobby"]];
    NSString * age = [self toString:[myInfo objectForKey:@"birthdate"]];
    NSString * phoneNum = [self toString:[myInfo objectForKey:@"phoneNumber"]];
    NSString * userId = [self toString:[myInfo objectForKey:@"id"]];
    NSString * theCity = [self toString:[myInfo objectForKey:@"city"]];
 
    if (myUserName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myUserName];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext]; 
            dFriend.userName = myUserName;
            dFriend.nickName = nickName?(nickName.length>1?nickName:[nickName stringByAppendingString:@" "]):@"";
            dFriend.gender = gender?gender:@"";
            dFriend.userId = userId?userId:@"";
            dFriend.hobby = hobby?hobby:@"";
            dFriend.headImgID = headImgID?headImgID:@"";
            dFriend.signature = signature?signature:@"";
            dFriend.phoneNumber = phoneNum;
            dFriend.age = age?age:@"";
            dFriend.theCity = theCity?theCity:@"未知";
            dFriend.backgroundImg = background;
            NSString * nameIndex;
            NSString * nameKey;
            if (nickName.length>=1) {
                nameKey = [[DataStoreManager convertChineseToPinYin:nickName] stringByAppendingFormat:@"+%@%@",nickName,myUserName];
                dFriend.nameKey = nameKey;
                nameIndex = [[nameKey substringToIndex:1] uppercaseString];
                dFriend.nameIndex = nameIndex;
            }
//            else{
//                nameKey = [[DataStoreManager convertChineseToPinYin:myUserName] stringByAppendingFormat:@"+%@",myUserName];;
//                dFriend.nameKey = nameKey;
//                nameIndex = [[nameKey substringToIndex:1] uppercaseString];
//                dFriend.nameIndex = nameIndex;
//            }
            if (![myUserName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                if (nickName.length>=1) {
                    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                    DSNameIndex * dFname = [DSNameIndex MR_findFirstWithPredicate:predicate2];
                    if (!dFname)
                        dFname = [DSNameIndex MR_createInContext:localContext];
                    
                    dFname.index = nameIndex;
                    
                    [[TempData sharedInstance] friendsArrayAddNameKey:nameKey];
                }
            
                
            }
        }];
      //  [self storePetInfo:myInfo];
      } 
}
+(void)saveMyBackgroungImg:(NSString*)backgroundImg
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (!dFriend)
            dFriend = [DSFriends MR_createInContext:localContext];
        dFriend.backgroundImg = backgroundImg;
    }];
}
+(void)storePetInfo:(NSDictionary *)myInfo
{
    NSArray * petArray = [myInfo objectForKey:@"petInfoViews"];

    for (int i = 0; i<petArray.count; i++) {
        NSString * hostName = [myInfo objectForKey:@"username"];
        NSString * hostNickName = [myInfo objectForKey:@"nickname"];
        NSString * nickName = [[petArray objectAtIndex:i] objectForKey:@"nickname"];
        NSString * gender = [[petArray objectAtIndex:i] objectForKey:@"gender"];
        NSString * headImgID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"img"]];
        NSString * trait = [[petArray objectAtIndex:i] objectForKey:@"trait"];
        NSString * type = [self toString:[[petArray objectAtIndex:i] objectForKey:@"type"]];
        NSString * age = [self toString:[[petArray objectAtIndex:i] objectForKey:@"birthdate"]];
        NSString * petID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"id"]];
        NSString * userID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"userid"]];
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
            DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
            if (!dPet)
                dPet = [DSPets MR_createInContext:localContext];
            dPet.friendName = hostName?hostName:@"";
            dPet.friendNickname = hostNickName?hostNickName:@"";
            dPet.petNickname = nickName?nickName:@"";
            dPet.petGender = gender?gender:@"";
            dPet.petHeadImgID = headImgID?headImgID:@"";
            dPet.petTrait = trait?trait:@"";
            dPet.petType = type?type:@"";
            dPet.petAge = age?age:@"";
            dPet.petID = petID?petID:@"";
            dPet.userID = userID?userID:@"";
        }];
    }
}

+(void)storeOnePetInfo:(NSDictionary *)petInfo
{

    NSString * nickName = [petInfo objectForKey:@"nickname"];
    NSString * gender = [petInfo objectForKey:@"gender"];
    NSString * headImgID = [self toString:[petInfo objectForKey:@"img"]];
    NSString * trait = [petInfo objectForKey:@"trait"];
    NSString * type = [self toString:[petInfo objectForKey:@"type"]];
    NSString * age = [self toString:[petInfo objectForKey:@"birthdate"]];
    NSString * petID = [self toString:[petInfo objectForKey:@"id"]];
    NSString * userID = [self toString:[petInfo objectForKey:@"userid"]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
        DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
        if (!dPet)
            dPet = [DSPets MR_createInContext:localContext];
        dPet.petNickname = nickName?nickName:@"";
        dPet.petGender = gender?gender:@"";
        dPet.petHeadImgID = headImgID?headImgID:@"";
        dPet.petTrait = trait?trait:@"";
        dPet.petType = type?type:@"";
        dPet.petAge = age?age:@"";
        dPet.petID = petID?petID:@"";
        dPet.userID = userID?userID:@"";
    }];
}

+(void)deleteOnePetForPetID:(NSString *)petID
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
        DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
        if (dPet) {
            [dPet MR_deleteInContext:localContext];
        }
    }];
}

+(NSMutableDictionary *)queryOneFriendInfoWithUserName:(NSString *)userName
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        [dict setObject:dFriend.userName forKey:@"username"];
        [dict setObject:dFriend.userId?dFriend.userId:@"" forKey:@"userid"];
        [dict setObject:dFriend.nickName?dFriend.nickName:@"" forKey:@"nickname"];
        [dict setObject:dFriend.gender?dFriend.gender:@"" forKey:@"gender"];
        [dict setObject:dFriend.signature?dFriend.signature:@"" forKey:@"signature"];
        [dict setObject:dFriend.hobby?dFriend.hobby:@"" forKey:@"hobby"];
        [dict setObject:@"0" forKey:@"latitude"];
        [dict setObject:@"0" forKey:@"longitude"];
        [dict setObject:dFriend.age?dFriend.age:@"" forKey:@"birthdate"];
        [dict setObject:dFriend.headImgID?dFriend.headImgID:@"" forKey:@"img"];
        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"friendName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        NSArray * tempArray = [DSPets MR_findAllWithPredicate:predicate2];
        NSMutableArray * petArray = [NSMutableArray array];
        for (DSPets * petThis in tempArray) {
            NSMutableDictionary * petDict = [NSMutableDictionary dictionary];
            [petDict setObject:petThis.petNickname forKey:@"nickname"];
            [petDict setObject:petThis.petType forKey:@"type"];
            [petDict setObject:petThis.petTrait forKey:@"trait"];
            [petDict setObject:petThis.petGender forKey:@"gender"];
            [petDict setObject:petThis.petAge forKey:@"birthdate"];
            [petDict setObject:petThis.petHeadImgID forKey:@"img"];
            [petArray addObject:petDict];
        }
        [dict setObject:petArray forKey:@"petInfoViews"];
        
    }
    return dict;
    
}


+(NSDictionary *)queryMyInfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        [dict setObject:dFriend.userName forKey:@"username"];
        [dict setObject:dFriend.userId forKey:@"id"];
        [dict setObject:dFriend.nickName forKey:@"nickname"];
        [dict setObject:dFriend.gender forKey:@"gender"];
        [dict setObject:dFriend.signature forKey:@"signature"];
        [dict setObject:dFriend.hobby forKey:@"hobby"];
        [dict setObject:dFriend.phoneNumber forKey:@"phoneNumber"];
        [dict setObject:@"0" forKey:@"latitude"];
        [dict setObject:@"0" forKey:@"longitude"];
        [dict setObject:dFriend.age forKey:@"birthdate"];
        [dict setObject:dFriend.headImgID forKey:@"img"];
        [dict setObject:dFriend.theCity forKey:@"city"];
        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"userID==[c]%@",dFriend.userId];
        NSArray * tempArray = [DSPets MR_findAllWithPredicate:predicate2];
        NSMutableArray * petArray = [NSMutableArray array];
        for (DSPets * petThis in tempArray) {
            NSMutableDictionary * petDict = [NSMutableDictionary dictionary];
            [petDict setObject:petThis.petNickname forKey:@"nickname"];
            [petDict setObject:petThis.petType forKey:@"type"];
            [petDict setObject:petThis.petTrait forKey:@"trait"];
            [petDict setObject:petThis.petID forKey:@"id"];
            [petDict setObject:petThis.petGender forKey:@"gender"];
            [petDict setObject:petThis.petAge forKey:@"birthdate"];
            [petDict setObject:petThis.petHeadImgID forKey:@"img"];
            [petArray addObject:petDict];
            if (petArray.count>=8) {
                break;
            }
        }
        [dict setObject:petArray forKey:@"petInfoViews"];
        [dict setObject:dFriend.backgroundImg forKey:@"backgroundImg"];
        
    }
    return dict;
}

+(NSString *)toString:(id)object
{
    return [NSString stringWithFormat:@"%@",object?object:@""];
}
#pragma mark - 打招呼存储相关
+(void)addPersonToSayHellos:(NSDictionary *)userInfoDict
{
    
}

+(void)deleteReceivedHelloWithUserName:(NSString *)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        NSArray * received = [DSReceivedHellos MR_findAllWithPredicate:predicate];
        for (int i = 0; i<received.count; i++) {
            DSReceivedHellos * rH = [received objectAtIndex:i];
            [rH MR_deleteInContext:localContext];
        }
    }];

}

+(NSString *)qureyUnreadForReceivedHellos
{
//    DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
//    int theUnread = [unread.receivedHellosUnread intValue];
    NSArray * allReceived = [DSReceivedHellos MR_findAll];
    int theUnread = 0;
    for (int i = 0; i<allReceived.count; i++) {
        theUnread = theUnread + [[[allReceived objectAtIndex:i] unreadCount] intValue];
    }
    return [NSString stringWithFormat:@"%d",theUnread];
}

+(void)blankReceivedHellosUnreadCount
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
        unread.receivedHellosUnread = @"0";
    }];

}

+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict
{
    NSString * userName = [userInfoDict objectForKey:@"fromUser"];
    NSString * userNickname = [userInfoDict objectForKey:@"fromNickname"];
    NSString * addtionMsg = [userInfoDict objectForKey:@"addtionMsg"];
    NSString * headID = [self toString:[userInfoDict objectForKey:@"headID"]];
    NSDate * receiveTime = [NSDate date];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (!dReceivedHellos)
        {
            dReceivedHellos = [DSReceivedHellos MR_createInContext:localContext];
        }
        dReceivedHellos.userName = userName;
        dReceivedHellos.nickName = userNickname?userNickname:@"";
        dReceivedHellos.addtionMsg = addtionMsg?addtionMsg:@"";
        dReceivedHellos.headImgID = headID?headID:@"";
        dReceivedHellos.receiveTime = receiveTime;
        dReceivedHellos.acceptStatus = @"waiting";
        if (dReceivedHellos.unreadCount.length>0) {
            dReceivedHellos.unreadCount = [NSString stringWithFormat:@"%d",[dReceivedHellos.unreadCount intValue]+1];
        }
        else
            dReceivedHellos.unreadCount = @"1";
        
        DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
        commonMsg.sender = userName;
        commonMsg.senderNickname = userNickname?userNickname:@"";
        commonMsg.msgContent = addtionMsg?addtionMsg:@"";
        commonMsg.senTime = receiveTime;
        
        DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
        if (!unread) {
            unread = [DSUnreadCount MR_createInContext:localContext];
            unread.receivedHellosUnread = @"1";
        }
        else
        {
            int theUnread = [unread.receivedHellosUnread intValue];
            unread.receivedHellosUnread = [NSString stringWithFormat:@"%d",theUnread+1];
        }
        
        
    }];
}
+(BOOL)ifSayHellosHaveThisPerson:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
    if (dReceivedHellos) {
        return YES;
    }
    else
        return NO;
}
+(BOOL)checkSayHelloPersonIfHaveNickNameForUsername:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
    if (dReceivedHellos) {
        if (dReceivedHellos.nickName.length>1) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (dReceivedHellos)
        {
            dReceivedHellos.acceptStatus = theStatus;
        }
    }];
}

+(void)qureyAllFriends
{
    
}
@end
