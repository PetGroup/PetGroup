//
//  DataStoreManager.m
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataStoreManager.h"

@implementation DataStoreManager
-(void)nothing
{}
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName
{
    [MagicalRecord cleanUp];
    [MagicalRecord setDefaultModelNamed:[NSString stringWithFormat:@"%@.momd",modelName]];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
}
#pragma mark - 存储消息相关
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype
{
    NSRange range = [[msg objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[msg objectForKey:@"sender"] substringToIndex:range.location];
    NSString * senderNickname = [msg objectForKey:@"nickname"];
    NSString * msgContent = [msg objectForKey:@"msg"];
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[msg objectForKey:@"time"] doubleValue]];
//    NSString * receiver;
//    if ([msg objectForKey:@"receicer"]) {
//        NSRange range2 = [[msg objectForKey:@"receicer"] rangeOfString:@"@"];
//        receiver = [[msg objectForKey:@"receicer"] substringToIndex:range2.location];
//    }
    
    //普通用户消息存储到DSCommonMsgs和DSThumbMsgs两个表里
    if ([sendertype isEqualToString:COMMONUSER]) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
            commonMsg.sender = sender;
            commonMsg.senderNickname = senderNickname?senderNickname:@"";
            commonMsg.msgContent = msgContent?msgContent:@"";
            commonMsg.senTime = sendTime;
            

            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate]; 
            if (!thumbMsgs) 
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];    
            thumbMsgs.sender = sender;
            thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            
        }];
    }
    //公共账号消息存储到DSThumbPuclicMsgs和DSPublicMsgs里面
    else if ([sendertype isEqualToString:PUBLICACCOUNT]){
        
    }
    //订阅号信息存储到DSThumbSubscribedMsgs和DSSubscribedMsgs里面
    else if ([sendertype isEqualToString:SUBSCRIBEDACCOUNT]){
        
    }
}
+(void)storeMyMessage:(NSDictionary *)message
{
    NSString * receicer = [message objectForKey:@"receiver"];
    NSString * sender = [message objectForKey:@"sender"];
    NSString * senderNickname = [message objectForKey:@"nickname"];
    NSString * msgContent = [message objectForKey:@"msg"];
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
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
        thumbMsgs.msgContent = msgContent;
        thumbMsgs.sendTime = sendTime;
        thumbMsgs.senderType = COMMONUSER;
        int unread = [thumbMsgs.unRead intValue];
        thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
        
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
+(void)deleteMsgsWithSender:(NSString *)sender
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        [thumbMsgs MR_deleteInContext:localContext];
        DSCommonMsgs * commonMsgs = [DSCommonMsgs MR_findFirstWithPredicate:predicate];
        [thumbMsgs MR_deleteInContext:localContext];
        [commonMsgs MR_deleteInContext:localContext];
    }];
}
+(NSMutableArray *)qureyAllCommonMessages:(NSString *)username
{
    NSMutableArray * allMsgArray = [NSMutableArray array];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@ OR receiver==[c]%@",username,username];
    NSArray * commonMsgsArray = [DSCommonMsgs MR_findAllSortedBy:@"senTime" ascending:YES withPredicate:predicate];
    for (int i = 0; i<commonMsgsArray.count; i++) {
        NSMutableDictionary * thumbMsgsDict = [NSMutableDictionary dictionary];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] sender] forKey:@"sender"];
        //        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] senderNickname] forKey:@"nickname"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] msgContent] forKey:@"msg"];
        NSDate * tt = [[commonMsgsArray objectAtIndex:i] senTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [thumbMsgsDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [allMsgArray addObject:thumbMsgsDict];
        
    }
    return allMsgArray;
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

+(NSArray *)queryAllReceivedHellos
{
    NSArray * rechellos = [DSReceivedHellos MR_findAllSortedBy:@"receiveTime" ascending:NO];
    NSMutableArray * hellosArray = [NSMutableArray array];
    for (int i = 0; i<rechellos.count; i++) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[[rechellos objectAtIndex:i] userName] forKey:@"userName"];
        [dict setObject:[[rechellos objectAtIndex:i] nickName] forKey:@"nickName"];
        NSRange range=[[[rechellos objectAtIndex:i] headImgID] rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [[[rechellos objectAtIndex:i] headImgID] componentsSeparatedByString:@","];
            [dict setObject:[imageArray objectAtIndex:0] forKey:@"headImgID"];
        }
        else
            [dict setObject:[[rechellos objectAtIndex:i] headImgID] forKey:@"headImgID"];
        [dict setObject:[[rechellos objectAtIndex:i] addtionMsg] forKey:@"addtionMsg"];
        [dict setObject:[[rechellos objectAtIndex:i] acceptStatus] forKey:@"acceptStatus"];
        [dict setObject:[[rechellos objectAtIndex:i] receiveTime] forKey:@"receiveTime"];
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
        [lastHelloDict setObject:[NSString stringWithFormat:@"%@向您打了一个招呼",[lastRecHello nickName]] forKey:@"msg"];
    }
    else
    {
        NSTimeInterval uu = [[NSDate date] timeIntervalSince1970];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastHelloDict setObject:@"暂时还没有收到招呼" forKey:@"msg"];
    }
    return lastHelloDict;
}

#pragma mark - 存储联系人相关
+(BOOL)ifHaveThisFriend:(NSString *)userName
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriends) {
        return YES;
    }
    else
        return NO;
}

+(void)addFriendToLocal:(NSDictionary *)userInfoDict
{
    NSString * userName = [userInfoDict objectForKey:@"username"];
    NSString * nickName = [userInfoDict objectForKey:@"nickname"];
    if (![self ifHaveThisFriend:userName]) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            DSFriends * dFriend = [DSFriends MR_createInContext:localContext];
            dFriend.userName = userName;
            dFriend.nickName = nickName;
        }];
    }
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
+(NSString *)queryNickNameForUser:(NSString *)userName
{
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
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        NSRange range=[dFriend.headImgID rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [dFriend.headImgID componentsSeparatedByString:@","];
            return [imageArray objectAtIndex:0];
        }
        else
            return dFriend.headImgID;
    }
    else
        return @"no";
}
#pragma mark - 存储个人信息
+(void)saveUserInfo:(NSDictionary *)myInfo
{
    NSString * myUserName = [myInfo objectForKey:@"username"];
    NSString * nickName = [self toString:[myInfo objectForKey:@"nickname"]];
    NSString * gender = [myInfo objectForKey:@"gender"];
    NSString * headImgID = [self toString:[myInfo objectForKey:@"img"]];
    NSString * signature = [myInfo objectForKey:@"signature"];
    NSString * hobby = [myInfo objectForKey:@"hobby"];
    NSString * age = [self toString:[myInfo objectForKey:@"birthdate"]];
    NSString * userId = [self toString:[myInfo objectForKey:@"userid"]];
 
    if (myUserName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myUserName];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext]; 
            dFriend.userName = myUserName;
            dFriend.nickName = nickName?nickName:@"";
            dFriend.gender = gender?gender:@"";
            dFriend.userId = userId?userId:@"";
            dFriend.hobby = hobby?hobby:@"";
            dFriend.headImgID = headImgID?headImgID:@"";
            dFriend.signature = signature?signature:@"";
            dFriend.age = age?age:@"";
        }];
        [self storePetInfo:myInfo];
      } 
}

+(void)storePetInfo:(NSDictionary *)myInfo
{
    NSArray * petArray = [myInfo objectForKey:@"petInfos"];
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
        }];
    }
}

+(NSString *)toString:(id)object
{
    return [NSString stringWithFormat:@"%@",object];
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
    DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
    int theUnread = [unread.receivedHellosUnread intValue];
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
    NSString * headID = [userInfoDict objectForKey:@"headID"];
    NSDate * receiveTime = [NSDate date];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (!dReceivedHellos)
        {
            dReceivedHellos = [DSReceivedHellos MR_createInContext:localContext];
            dReceivedHellos.userName = userName;
            dReceivedHellos.nickName = userNickname?userNickname:@"";
            dReceivedHellos.addtionMsg = addtionMsg?addtionMsg:@"";
            dReceivedHellos.headImgID = headID?headID:@"";
            dReceivedHellos.receiveTime = receiveTime;
            dReceivedHellos.acceptStatus = @"waiting";
            
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
