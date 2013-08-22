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
    NSDate * sendTime = [msg objectForKey:@"time"];
    if ([sendertype isEqualToString:COMMONUSER]) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
            commonMsg.sender = sender;
            commonMsg.senderNickname = senderNickname;
            commonMsg.msgContent = msgContent;
            commonMsg.senTime = sendTime;
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate]; 
            if (!thumbMsgs) 
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];    
            thumbMsgs.sender = sender;
            thumbMsgs.senderNickname = senderNickname;
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            
        }];
    }
    else if ([sendertype isEqualToString:PUBLICACCOUNT]){
        
    }
    else if ([sendertype isEqualToString:SUBSCRIBEDACCOUNT]){
        
    }
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

#pragma mark - 存储个人信息
+(void)saveMyInfo:(NSDictionary *)myInfo
{
    NSString * myName = [SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
    NSString * nickName = [myInfo objectForKey:@"nickname"];
    if (myName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myName];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext];    
            dFriend.userName = myName;
            dFriend.nickName = nickName;

        }];
      } 
}

#pragma mark - 打招呼存储相关
+(void)addPersonToSayHellos:(NSDictionary *)userInfoDict
{
    
}

+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict
{
    
}

+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userName
{
    
}

+(void)qureyAllFriends
{
    
}
@end
