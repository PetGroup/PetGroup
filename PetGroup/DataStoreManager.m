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
    NSString * myUserName = [SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
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

+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict
{
    NSString * userName = [userInfoDict objectForKey:@"fromUser"];
    NSString * userNickname = [userInfoDict objectForKey:@"fromNickname"];
    NSString * addtionMsg = [userInfoDict objectForKey:@"addtionMsg"];
    NSString * headID = [userInfoDict objectForKey:@"headID"];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (!dReceivedHellos)
        {
            dReceivedHellos = [DSReceivedHellos MR_createInContext:localContext];
            dReceivedHellos.userName = userName;
            dReceivedHellos.nickName = userNickname;
            dReceivedHellos.addtionMsg = addtionMsg;
            dReceivedHellos.headImgID = headID;
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
    
}

+(void)qureyAllFriends
{
    
}
@end
